#!/usr/bin/env python3
"""Check the cluster levels (4 to 7, 9 to 11) of the checkpoint missions.

usage: check_job.py LEVEL DIRECTORY START_EPOCH

LEVEL        4 to 7: Slurm signals, 9: local DMTCP, 10 and 11: DMTCP in Slurm
DIRECTORY    the level's directory, containing submit.sh and the python script
START_EPOCH  time (seconds since epoch) when the mission started: older jobs
             and files are ignored

The job is found with sacct, from its name (ckpt_levelN). Exit code 0 means
the mission is validated.
"""

import glob

import os
import re
import shlex
import subprocess
import sys
import time

MAX_WALLTIME = 5 * 60
# Slurm only checks its signal timers about once a minute: a signal asked
# "@N" can arrive up to 60 seconds earlier than N seconds before the end.
SIGNAL_SLACK = 90
# Level 7: max value for STOP in count_signal.py, so that the whole run does
# not take forever.
MAX_STOP = 150
CHECKPOINT = "checkpoint.txt"

FINISHED = {"COMPLETED", "FAILED", "TIMEOUT", "CANCELLED", "NODE_FAIL",
            "OUT_OF_MEMORY", "PREEMPTED", "BOOT_FAIL", "DEADLINE"}


class Failure(Exception):
    pass


# ---------------------------------------------------------------------------
# small parsers

def parse_duration(text):
    """Slurm duration ([D-]HH:MM:SS, MM:SS, MM, ...) to seconds, or None."""
    text = text.strip()
    if not text or not re.match(r"^[\d:.-]+$", text):
        return None
    days = 0
    if "-" in text:
        d, text = text.split("-", 1)
        days = int(d)
        parts = [int(float(p)) for p in text.split(":")]
        # with days: D-HH, D-HH:MM, D-HH:MM:SS
        while len(parts) < 3:
            parts.append(0)
    else:
        parts = [int(float(p)) for p in text.split(":")]
        # without days: MM, MM:SS, HH:MM:SS
        if len(parts) == 1:
            parts = [0, parts[0], 0]
        elif len(parts) == 2:
            parts = [0] + parts
    h, m, s = parts[-3:]
    return ((days * 24 + h) * 60 + m) * 60 + s


def tilde(path):
    """PATH relative to the player's home (GSH_HOME), as ~/..."""
    home = os.environ.get("GSH_HOME")
    if home and path:
        home, real = os.path.realpath(home), os.path.realpath(path)
        if real == home:
            return "~"
        if real.startswith(home + os.sep):
            return "~" + real[len(home):]
    return path


def same_dir(a, b):
    return os.path.realpath(a) == os.path.realpath(b)


def fmt(seconds):
    m, s = divmod(int(seconds), 60)
    return f"{m}m{s:02d}s"


class SubmitScript:
    """The #SBATCH options and the commands of a submission script."""

    SHORT = {"-J": "job-name", "-o": "output", "-t": "time"}

    def __init__(self, path):
        self.path = path
        self.options = {}
        self.commands = []
        # (line, why) for the lines meant for sbatch, but that it ignores
        self.ignored = []
        with open(path) as f:
            lines = f.read().splitlines()
        in_header = True
        for line in lines:
            stripped = line.strip()
            if not stripped:
                continue
            if stripped.startswith("#"):
                if stripped.startswith("#SBATCH"):
                    if in_header:
                        self._parse_option(stripped[len("#SBATCH"):])
                    else:
                        self.ignored.append((
                            stripped,
                            "sbatch stops reading the #SBATCH lines at the "
                            "first command of the script: move this line up, "
                            "with the other #SBATCH lines."))
                elif re.match(r"^#\s*sbatch\b", stripped, re.IGNORECASE):
                    self.ignored.append((
                        stripped,
                        "sbatch only reads the lines starting exactly with "
                        "'#SBATCH' (upper case, no space after the '#')."))
                continue
            in_header = False
            self.commands.append(stripped)

    def _parse_option(self, text):
        try:
            words = shlex.split(text, comments=True)
        except ValueError:
            words = text.split()
        it = iter(words)
        for word in it:
            if word.startswith("--"):
                key, sep, value = word[2:].partition("=")
                if not sep:
                    value = next(it, "") if key not in ("requeue",) else ""
                self.options[key] = value
            elif word in self.SHORT:
                self.options[self.SHORT[word]] = next(it, "")

    def get(self, key, default=None):
        return self.options.get(key, default)

    def has_command(self, *words):
        return any(all(w in c for w in words) for c in self.commands)

    def traps(self):
        """[(index of the command, [signals])] for the trap commands."""
        result = []
        for n, c in enumerate(self.commands):
            if not re.match(r"^trap\s", c):
                continue
            try:
                words = shlex.split(c, comments=True)
            except ValueError:
                words = c.split()
            sigs = [w.upper()[3:] if w.upper().startswith("SIG") else w.upper()
                    for w in words[2:]]
            sigs = [{"2": "INT", "10": "USR1", "12": "USR2", "15": "TERM"}
                    .get(x, x) for x in sigs]
            result.append((n, sigs))
        return result

    def depth(self, index):
        """Nesting depth (functions, if blocks) of command INDEX."""
        depth = 0
        for c in self.commands[:index]:
            if re.search(r"\{\s*$", c) or re.match(r"^if\b", c):
                depth += 1
            if re.match(r"^\}", c) or re.match(r"^fi\b", c):
                depth -= 1
        return depth

    def first(self, pattern):
        """Index of the first command matching PATTERN, or None."""
        for n, c in enumerate(self.commands):
            if re.search(pattern, c):
                return n
        return None

    def signal(self):
        """Return (to_batch, signal_name, seconds) or None."""
        spec = self.get("signal")
        if spec is None:
            return None
        m = re.match(r"^(?:([RB]+):)?([A-Za-z0-9]+)(?:@(\d+))?$", spec)
        if not m:
            raise Failure(f"I don't understand '--signal={spec}' in "
                          f"submit.sh.")
        flags, sig, delay = m.groups()
        sig = sig.upper()
        if sig.startswith("SIG"):
            sig = sig[3:]
        sig = {"2": "INT", "10": "USR1", "12": "USR2", "15": "TERM"}.get(sig,
                                                                       sig)
        return ("B" in (flags or ""), sig, int(delay) if delay else 60)


HEADER = re.compile(r"^=== job (\d+) started.*restart count: (\d+)")
FOOTER = re.compile(r"^=== job (\d+) ended")


def read_runs(path):
    """Split the output file in runs, using the header line printed by
    submit.sh. Return a list of [jobid, restart_count, numbers]. What is
    printed after the "ended" line of job JOBID gets the id "after:JOBID"."""
    runs = [[None, 0, []]]
    with open(path, errors="replace") as f:
        for line in f:
            line = line.strip()
            m = HEADER.match(line)
            if m:
                runs.append([m.group(1), int(m.group(2)), []])
                continue
            m = FOOTER.match(line)
            if m:
                runs.append(["after:" + m.group(1), 0, []])
            elif re.match(r"^-?\d+$", line):
                runs[-1][2].append(int(line))
    return runs


# ---------------------------------------------------------------------------
# sacct

def sacct(name, start, duplicates):
    since = time.strftime("%Y-%m-%dT%H:%M:%S", time.localtime(start - 120))
    base = ["sacct", "-n", "-P", "-X", "--name", name, "-S", since]
    if duplicates:
        base.append("-D")
    fields = ["JobID", "State", "Elapsed", "Timelimit", "End", "Submit",
              "WorkDir"]
    for attempt in (fields, fields[:-1]):
        proc = subprocess.run(base + ["-o", ",".join(attempt)],
                              stdout=subprocess.PIPE, stderr=subprocess.PIPE,
                universal_newlines=True)
        if proc.returncode == 0:
            break
    else:
        raise Failure("Could not run sacct:\n" + proc.stderr.strip())
    rows = []
    for line in proc.stdout.splitlines():
        cols = line.split("|")
        if len(cols) < 4 or not cols[0].strip():
            continue
        rows.append({
            "id": cols[0].strip(),
            "state": cols[1].split()[0] if cols[1].split() else "",
            "elapsed": parse_duration(cols[2]),
            "timelimit": parse_duration(cols[3]),
            "timelimit_raw": cols[3].strip(),
            "end": parse_date(cols[4]) if len(cols) > 4 else None,
            "submit": parse_date(cols[5]) if len(cols) > 5 else None,
            "workdir": cols[6].strip() if len(cols) > 6 else "",
        })
    return rows


def parse_date(text):
    try:
        return time.mktime(time.strptime(text.strip(), "%Y-%m-%dT%H:%M:%S"))
    except ValueError:
        return None


def job_key(row):
    m = re.match(r"^(\d+)", row["id"])
    return int(m.group(1)) if m else -1


# ---------------------------------------------------------------------------
# the checks

class Checker:

    def __init__(self, level, directory, start):
        self.level = level
        self.dir = directory
        self.start = start
        self.name = f"ckpt_level{level}"
        self.script = "count_signal.py" if level <= 7 else "count_nockpt.py"
        self.after = []
        self.submit = None
        self.signal = None
        self.stop = None

    # --- the submission script -------------------------------------------

    def check_script(self):
        path = os.path.join(self.dir, "submit.sh")
        if not os.path.isfile(path):
            raise Failure(f"The file {tilde(path)} does not exist anymore!")
        s = self.submit = SubmitScript(path)
        if s.ignored:
            line, why = s.ignored[0]
            raise Failure(f"In submit.sh, this line is ignored by sbatch:\n"
                          f"    {line}\n{why}")

        if s.get("job-name") != self.name:
            raise Failure(
                f"gsh check finds your job from its name: keep the line\n"
                f"    #SBATCH --job-name={self.name}\n"
                f"in submit.sh (and resubmit).")
        if s.get("open-mode") != "append":
            raise Failure(
                "Your submission script must contain\n"
                "    #SBATCH --open-mode=append\n"
                "Otherwise Slurm erases the output file each time the job "
                "(re)starts, and you lose the output of the previous runs.")
        walltime = parse_duration(s.get("time", "") or "")
        if walltime is None:
            raise Failure("Set the walltime of your job with --time in "
                          "submit.sh (less than 5 minutes).")
        if walltime > MAX_WALLTIME:
            raise Failure(
                f"The walltime of your job (--time={s.get('time')}) is too "
                f"long: use less than 5 minutes, so that your job can start "
                f"quickly.")
        if not s.has_command(self.script):
            raise Failure(f"Your submission script does not run "
                          f"{self.script} anymore!")

        self.signal = s.signal()
        if self.signal is not None and self.signal[2] >= walltime:
            raise Failure(
                f"With --signal={s.get('signal')}, the signal is sent "
                f"{self.signal[2]} seconds before the end of the walltime, "
                f"but the walltime (--time={s.get('time')}) is only "
                f"{walltime} seconds: the signal would be sent immediately. "
                f"Use a shorter delay, like @60.")
        if self.level in (4, 5) and not s.has_command("srun",
                                                      "count_signal.py"):
            raise Failure(
                "Start python with srun:\n"
                "    srun python3 -u count_signal.py\n"
                "The signal is sent to the job *steps* (what is started with "
                "srun), not to the submission script: without srun, python "
                "never receives it.")
        if self.level == 5:
            if self.signal is None:
                raise Failure(
                    "Ask Slurm to send the signal for you: add the line\n"
                    "    #SBATCH --signal=SIGINT@60\n"
                    "to the #SBATCH lines of submit.sh.")
            to_batch, sig, _ = self.signal
            if to_batch:
                raise Failure(
                    "With 'B:', the signal is sent to the submission script "
                    "only, not to python. That's for the next level: here, "
                    "use --signal=SIGINT@60.")
            if sig != "INT":
                raise Failure(
                    f"Your python script catches SIGINT, but you asked "
                    f"Slurm to send SIG{sig}.")
        if self.level in (6, 7):
            if self.signal is None or not self.signal[0]:
                raise Failure(
                    "Ask Slurm to send the signal to the submission script, "
                    "with the 'B:' prefix:\n"
                    "    #SBATCH --signal=B:USR1@60")
            self.check_trap(s)
        if self.level in (10, 11):
            if not s.has_command("dmtcp_launch", self.script):
                raise Failure(
                    "Your submission script must start python with "
                    "dmtcp_launch (see level 10).")
            self.check_trap(s)
        if self.level == 11:
            if self.signal is None or not self.signal[0]:
                raise Failure(
                    "Ask Slurm to send the signal to the submission script, "
                    "with the 'B:' prefix:\n"
                    "    #SBATCH --signal=B:USR1@60")
            if not s.has_command("dmtcp_restart_script"):
                raise Failure(
                    "When the job is requeued, your submission script must "
                    "restart the program from its checkpoint, with "
                    "./dmtcp_restart_script.sh (see the comments at the top "
                    "of submit.sh).")
        if self.level in (7, 11):
            requeue = s.first(r"scontrol\s+requeue")
            if requeue is not None and s.depth(requeue) == 0:
                raise Failure(
                    "In submit.sh, 'scontrol requeue' is run every time the "
                    "script reaches it, also when the computation is "
                    "finished: the job would be requeued forever. Requeue "
                    "only when the signal was received: in the function "
                    "called by the trap, or in an 'if' testing a variable "
                    "set by that function (see the comments at the top of "
                    "submit.sh).")
            if not s.has_command("scontrol", "requeue"):
                raise Failure(
                    "When the signal arrives, your submission script must "
                    "put the job back in the queue with\n"
                    "    scontrol requeue $SLURM_JOB_ID")
            self.check_stop()

    def check_trap(self, s):
        """The usual mistakes with trap, in levels 6, 7, 10 and 11."""
        traps = s.traps()
        if not traps:
            raise Failure(
                "Your submission script must catch the signal with 'trap' "
                "(see the comments at the top of submit.sh).")
        if self.signal is not None:
            sig = self.signal[1]
            if not any(sig in sigs for _, sigs in traps):
                caught = ", ".join(x for _, sigs in traps for x in sigs)
                raise Failure(
                    f"Slurm sends SIG{sig} (--signal={s.get('signal')}), but "
                    f"your trap catches {caught or 'nothing'}: use the same "
                    f"signal in both, for instance 'trap on_signal {sig}'.")
        launch = s.first(r"\bsrun\b|dmtcp_launch|dmtcp_restart")
        if launch is not None and traps[0][0] > launch:
            raise Failure(
                "In submit.sh, the 'trap' command comes after the start of "
                "the program: if the signal arrives before bash runs the "
                "trap command, the script is simply killed. Put the trap "
                "(and the function it calls) before srun.")
        if not s.has_command("wait"):
            raise Failure(
                "Bash runs a trap only when the current *foreground* command "
                "is finished: with a plain 'srun ...', your trap would only "
                "run after python is finished, i.e. after the end of the "
                "walltime. Start srun in the background, and wait for it:\n"
                "    srun python3 -u count_signal.py &\n"
                "    wait\n"
                "    wait")
        if self.level in (6, 7) and not s.has_command("scancel") and \
                re.search(r"^\s*kill\b", "\n".join(s.commands), re.M):
            raise Failure(
                "To forward the signal to python, use "
                "'scancel -s SIGINT $SLURM_JOB_ID'. With 'kill -INT PID' on "
                "srun, srun keeps the first Control-c for itself (it prints "
                "the state of the job steps) and python never receives it.")

    def check_stop(self):
        path = os.path.join(self.dir, self.script)
        stop = None
        try:
            with open(path) as f:
                for line in f:
                    m = re.match(r"^\s*STOP\s*=\s*(\d+)", line)
                    if m:
                        stop = int(m.group(1))
        except OSError:
            raise Failure(f"The file {tilde(path)} does not exist anymore!")
        if stop is None:
            raise Failure(
                f"I can't find the line 'STOP = ...' in {tilde(path)}. Put it back "
                f"(with a value of about 80).")
        if stop > MAX_STOP:
            raise Failure(
                f"STOP = {stop} in {self.script}: the full computation "
                f"would take {fmt(stop)}, that's too long for a training. "
                f"Use a value of about 80 (and at most {MAX_STOP}).")
        self.stop = stop

    # --- the job ------------------------------------------------------------

    def find_job(self):
        rows = sacct(self.name, self.start,
                     duplicates=(self.level in (7, 11)))
        if not rows:
            raise Failure(
                f"I can't find any job named '{self.name}' submitted since "
                f"the start of this mission. Submit it with\n"
                f"    sbatch submit.sh\n"
                f"(from {tilde(self.dir)}).")
        # ignore the jobs submitted before the start of the mission (sacct
        # also lists the jobs that were still running at that time); for a
        # requeued job, its first submission counts
        first_submit = {}
        for r in rows:
            if r["submit"] is not None:
                first_submit[r["id"]] = min(first_submit.get(r["id"], r["submit"]),
                                            r["submit"])
        rows = [r for r in rows
                if first_submit.get(r["id"], self.start) >= self.start - 30]
        if not rows:
            raise Failure(
                f"I can't find any job named '{self.name}' submitted since "
                f"the start of this mission. Submit it with\n"
                f"    sbatch submit.sh\n"
                f"(from {tilde(self.dir)}).")
        here = [r for r in rows
                if r["workdir"] and same_dir(r["workdir"], self.dir)]
        last = max(job_key(r) for r in (here or rows))
        rows = [r for r in rows if job_key(r) == last]
        return rows

    def lost_progress(self, job):
        """For a requeued job: did a run restart without the progress of
        the previous one? Return a message, or None."""
        jobid = re.match(r"^\d+", job["id"]).group(0)
        workdir = job["workdir"] if os.path.isdir(job["workdir"]) else self.dir
        try:
            runs = [r for r in read_runs(self.output_path(job, workdir))
                    if r[0] == jobid and r[2]]
        except OSError:
            return None
        for prev, cur in zip(runs, runs[1:]):
            if cur[2][0] < prev[2][-1] - 1:
                return (
                    f"Job {jobid} was requeued, but the new run restarted "
                    f"from {cur[2][0]}, while the previous one had reached "
                    f"{prev[2][-1]}: the progress was not saved before the "
                    f"requeue, and the job may never finish. Cancel it with "
                    f"'scancel {jobid}', and requeue only after python has "
                    f"saved its progress: in on_signal, 'wait' for python "
                    f"after the scancel, then requeue.")
        return None

    def waiting_message(self, job, rows):
        jobid, state = job["id"], job["state"]
        msg = f"Your job {jobid} is {state}."
        if self.level == 4:
            msg += (
                "\nWait until a few numbers are printed in its output "
                "(tail -f count.out, Control-c to stop following it), then "
                "send it the Control-c signal with\n"
                f"    scancel -s SIGINT {jobid}\n"
                "Run gsh check again once the job is finished "
                "(squeue --me).")
        elif self.level == 10:
            msg += (
                "\nWait until a few numbers are printed in its output "
                "(tail -f count.out, Control-c to stop following it), then "
                "ask the batch script to checkpoint with\n"
                f"    scancel --batch -s USR1 {jobid}\n"
                "Run gsh check again once the job is finished and you "
                "restarted the counter on the login node.")
        elif self.level in (5, 6):
            msg += (
                "\nWait for Slurm to send the signal, shortly before the end "
                "of the walltime (do not send it yourself!). Run gsh check "
                "again once the job is finished (squeue --me).")
        else:
            requeued = sum(1 for r in rows if r["state"] == "REQUEUED")
            msg += f" It was requeued {requeued} time(s) so far."
            if requeued and state in ("PENDING", "REQUEUED"):
                msg += (
                    "\nThat's expected: a requeued job does not restart "
                    "immediately. Slurm keeps it PENDING for a while "
                    "(squeue --me shows the reason 'BeginTime'), then it "
                    "waits for a free node. Don't resubmit it.")
            msg += (
                "\n"
                "Let it count up to STOP: it should be requeued "
                "automatically, without your help. Run gsh check again once "
                "it is COMPLETED (squeue --me, sacct -D -X -j "
                f"{jobid}).")
        return msg

    def check_job(self):
        try:
            self._check_job()
        except Failure as e:
            job = getattr(self, "job", None)
            path = os.path.join(self.dir, "submit.sh")
            if job and job["submit"] and job["state"] in FINISHED and \
                    os.stat(path).st_mtime > job["submit"] + 1:
                raise Failure(
                    f"{e}\n\nNote: you modified submit.sh after submitting "
                    f"job {job['id']}, so that job ran the old version. "
                    f"Submit it again with 'sbatch submit.sh'.")
            raise

    def _check_job(self):
        rows = self.find_job()
        # the runs that were requeued are listed with the state REQUEUED,
        # the current (or last) run has another state
        job = next((r for r in reversed(rows) if r["state"] != "REQUEUED"),
                   rows[-1])
        self.job = job
        jobid, state = job["id"], job["state"]

        if job["workdir"] and not same_dir(job["workdir"], self.dir):
            msg = (
                f"Your job {jobid} was submitted from {tilde(job['workdir'])}"
                f". A job runs in the directory where you typed 'sbatch': "
                f"there, it looks for {self.script} and writes count.out. "
                f"Submit it again from the right directory:\n"
                f"    cd {tilde(self.dir)}\n"
                f"    sbatch submit.sh")
            if state not in FINISHED:
                msg += (f"\n(and cancel the wrong one first, with "
                        f"'scancel {jobid}')")
            raise Failure(msg)

        if self.level in (7, 11) and self.lost_progress(job):
            raise Failure(self.lost_progress(job))
        if state not in FINISHED:
            raise Failure(self.waiting_message(job, rows))

        if job["timelimit"] is None or job["timelimit"] > MAX_WALLTIME:
            raise Failure(
                f"Your job {jobid} had a walltime of "
                f"{job['timelimit_raw']}: use less than 5 minutes "
                f"(--time) and submit it again.")

        if state == "TIMEOUT":
            hint = {
                4: "You must send the signal with "
                   "'scancel -s SIGINT JOBID' while the job is running "
                   "(without --batch: with --batch, the signal goes to the "
                   "submission script, not to python).",
                5: "Python did not receive the signal in time: did you start "
                   "it with srun?",
                6: "The trap of your submission script did not stop python: "
                   "remember that bash only runs a trap when the current "
                   "foreground command is finished. Start srun in the "
                   "background (&) and 'wait' for it, and forward the signal "
                   "to python with 'scancel -s SIGINT $SLURM_JOB_ID'.",
                7: "The trap of your submission script did not stop and "
                   "requeue the job: start srun in the background (&), "
                   "'wait' for it, forward the signal to python with "
                   "'scancel -s SIGINT $SLURM_JOB_ID', and requeue.",
                10: "You must send the signal to the batch script with "
                    "'scancel --batch -s USR1 JOBID' while the job is "
                    "running.",
                11: "The trap of your submission script did not checkpoint "
                    "and requeue the job: did you add "
                    "'#SBATCH --signal=B:USR1@60'?",
            }[self.level]
            raise Failure(
                f"Your job {jobid} was killed by Slurm when it reached its "
                f"walltime (state TIMEOUT): the progress made since the last "
                f"checkpoint is lost.\n{hint}")
        if state == "CANCELLED":
            if self.level == 4:
                hint = ("'scancel JOBID' without '-s' kills the job: python "
                        "never gets the chance to save its progress. Use "
                        "'scancel -s SIGINT JOBID'.")
            elif self.level == 10:
                hint = ("'scancel JOBID' without '-s' kills the job before "
                        "DMTCP can checkpoint it. Use "
                        "'scancel --batch -s USR1 JOBID'.")
            else:
                hint = ("The job must stop by itself, after the signal sent "
                        "by Slurm.")
            raise Failure(f"Your job {jobid} was cancelled.\n{hint}")
        if state not in ("COMPLETED", "FAILED"):
            raise Failure(f"Your job {jobid} ended in state {state}. Try "
                          f"again (sbatch submit.sh).")

        workdir = job["workdir"] if os.path.isdir(job["workdir"]) else self.dir
        # The files are written on the compute node: on a network file
        # system, the login node may only see them a few seconds after the
        # end of the job. Retry for a while if the job just finished.
        recent = job["end"] is not None and time.time() - job["end"] < 60
        for attempt in range(5 if recent else 1):
            try:
                self.check_files(job, rows, workdir)
                return
            except Failure:
                if attempt == (4 if recent else 0):
                    raise
                os.listdir(workdir)
                time.sleep(3)

    def check_files(self, job, rows, workdir):
        numbers, starts = self.check_output(job, workdir)

        if self.level in (7, 11):
            self.check_requeue(job, rows, numbers, starts)
        elif self.level == 10:
            self.check_dmtcp_job(job, workdir, numbers)
        else:
            self.check_checkpoint(job, workdir, numbers)
            if self.level in (5, 6):
                self.check_timing(job)

    def output_path(self, job, workdir):
        out = self.submit.get("output") or "slurm-%j.out"
        jobid = re.match(r"^\d+", job["id"]).group(0)
        out = (out.replace("%j", jobid).replace("%J", jobid)
                  .replace("%x", self.name)
                  .replace("%u", os.environ.get("USER", "")))
        return os.path.join(workdir, out)

    def check_output(self, job, workdir):
        path = self.output_path(job, workdir)
        if not os.path.isfile(path):
            raise Failure(f"I can't find the output of job {job['id']} "
                          f"({tilde(path)}).")
        jobid = re.match(r"^\d+", job["id"]).group(0)
        runs = read_runs(path)
        mine = [r for r in runs if r[0] == jobid]
        if not mine:
            # header line removed from submit.sh: use the whole file
            mine = runs
        numbers = [n for r in mine for n in r[2]]
        starts = [r[1] for r in mine if r[0] is not None]
        self.after = [n for r in runs if r[0] == "after:" + jobid
                      for n in r[2]]
        if not numbers:
            raise Failure(
                f"Job {job['id']} printed no numbers in {tilde(path)}: did python "
                f"run correctly? Have a look at that file.")
        return numbers, starts

    def check_checkpoint(self, job, workdir, numbers):
        path = os.path.join(workdir, CHECKPOINT)
        if not os.path.isfile(path) or os.stat(path).st_mtime < self.start:
            raise Failure(
                f"Job {job['id']} is finished, but python did not save its "
                f"progress in {tilde(path)}: it never received the signal, or did "
                f"not handle it.")
        with open(path) as f:
            content = f.read().strip()
        try:
            value = int(content)
        except ValueError:
            raise Failure(f"{tilde(path)} should contain a single number, not "
                          f"'{content[:40]}'.")
        last = numbers[-1]
        if value not in (last - 1, last, last + 1):
            raise Failure(
                f"Job {job['id']} printed up to {last}, but {CHECKPOINT} "
                f"contains {value}. Did you send the signal to the right "
                f"job, and run gsh check from the right level?")

    def check_timing(self, job):
        _, _, delay = self.signal
        elapsed, limit = job["elapsed"], job["timelimit"]
        if elapsed is None:
            return
        earliest = limit - delay - SIGNAL_SLACK
        if elapsed < earliest:
            raise Failure(
                f"Job {job['id']} stopped after {fmt(elapsed)}, too early "
                f"for the signal you asked to Slurm (walltime {fmt(limit)}, "
                f"signal {delay}s before the end). Don't send the signal "
                f"yourself: let Slurm do it, and submit again.")

    def check_image(self, workdir, hint):
        images = [f for f in glob.glob(os.path.join(workdir, "ckpt_*.dmtcp"))
                  if os.stat(f).st_mtime >= self.start]
        if not images:
            raise Failure(f"I can't find any recent DMTCP checkpoint image "
                          f"(ckpt_*.dmtcp) in {tilde(workdir)}. {hint}")

    def check_not_running(self, output):
        """The restarted counter must be stopped: its output must not grow.
        (A program restarted by DMTCP is called "[DMTCP:python3]" in ps.)"""
        try:
            before = os.stat(output).st_size
            time.sleep(2.2)
            after = os.stat(output).st_size
        except OSError:
            return
        if after != before:
            raise Failure(
                f"The counter is still running: {tilde(output)} keeps growing. "
                f"Stop it with 'dmtcp_command --quit' (in the shell where "
                f"you restarted it), or with 'pkill -f DMTCP:python3'.")

    def check_dmtcp_job(self, job, workdir, numbers):
        path = self.output_path(job, workdir)
        self.check_image(
            workdir,
            "Send USR1 to the batch script, with "
            "'scancel --batch -s USR1 JOBID' (without --batch, the signal "
            "goes to python, which simply dies).")
        log = os.path.join(workdir, "restart.log")
        if not self.after and job["end"] and os.path.exists(log) and \
                os.stat(log).st_mtime > job["end"]:
            raise Failure(
                f"It looks like you restarted the counter (restart.log is "
                f"there), but it printed nothing in count.out after the end "
                f"of job {job['id']}. Restarting takes a few seconds: restart "
                f"it again, and look at count.out (tail count.out) before "
                f"stopping it with 'dmtcp_command --quit'. If it still "
                f"prints nothing, look at restart.log.")
        if not self.after:
            raise Failure(
                f"Job {job['id']} is finished and the checkpoint image is "
                f"there. Now restart the counter on the login node, from "
                f"{tilde(workdir)}:\n"
                f"    . ./start_coordinator.sh\n"
                f"    ./dmtcp_restart_script.sh -h $DMTCP_COORD_HOST "
                f"-p $DMTCP_COORD_PORT >> count.out 2> restart.log &\n"
                f"and check that it continues in count.out.")
        first, last = self.after[0], numbers[-1]
        if first == 0:
            raise Failure(
                "After the job, the counter started again from 0: it was "
                "not restarted from its checkpoint. Use "
                "./dmtcp_restart_script.sh to restart it.")
        if first > last + 1:
            raise Failure(
                f"The job stopped at {last}, but the counter restarted at "
                f"{first}: that is not the checkpoint of this job.")
        self.check_not_running(path)

    def check_local(self):
        """Level 9: DMTCP on the login node, no Slurm."""
        self.check_image(
            self.dir,
            "Checkpoint the counter with 'dmtcp_command --bcheckpoint' "
            "(from the shell where you started the coordinator).")
        if not os.path.exists(os.path.join(self.dir,
                                           "dmtcp_restart_script.sh")):
            raise Failure("dmtcp_restart_script.sh is missing: checkpoint "
                          "the counter again.")
        path = os.path.join(self.dir, "count.out")
        if not os.path.isfile(path):
            raise Failure(
                "I can't find count.out: start the counter with\n"
                "    dmtcp_launch python3 -u count_nockpt.py >> count.out &")
        numbers = [n for r in read_runs(path) for n in r[2]]
        restarted = [b for a, b in zip(numbers, numbers[1:]) if b <= a]
        if numbers and numbers[0] > 0 and not restarted:
            raise Failure(
                f"count.out starts at {numbers[0]}: the beginning was "
                f"erased. Did you use '> count.out'? '>' empties the file "
                f"first, '>>' adds at the end. Start again: remove count.out "
                f"and the checkpoint files (rm count.out ckpt_*.dmtcp "
                f"dmtcp_restart_script*.sh), and use '>>' every time.")
        if not restarted:
            raise Failure(
                "count.out doesn't show the counter going back to its "
                "checkpoint. After the checkpoint, wait a few numbers before "
                "'dmtcp_command --quit', and restart with\n"
                "    ./dmtcp_restart_script.sh -h $DMTCP_COORD_HOST "
                "-p $DMTCP_COORD_PORT >> count.out 2> restart.log &")
        if all(b == 0 for b in restarted):
            raise Failure(
                "In count.out, the counter started again from 0: it was "
                "not restarted from its checkpoint. Use "
                "./dmtcp_restart_script.sh to restart it.")
        self.check_not_running(path)

    def check_requeue(self, job, rows, numbers, starts):
        requeued = sum(1 for r in rows if r["state"] == "REQUEUED")
        restarts = max(starts) if starts else 0
        if job["state"] != "COMPLETED":
            raise Failure(
                f"Your job {job['id']} ended in state {job['state']}, not "
                f"COMPLETED. Look at count.out to see what happened.")
        if requeued == 0 and restarts == 0:
            raise Failure(
                f"Job {job['id']} was never requeued: it finished in a "
                f"single run. Check that the trap calls "
                f"'scontrol requeue $SLURM_JOB_ID', remove the old "
                f"{CHECKPOINT} (so that python starts from 0 again) and "
                f"submit again.")
        if len(starts) < 2:
            raise Failure(
                f"Job {job['id']} was requeued, but its output file only "
                f"contains the last run: did you keep "
                f"'--open-mode=append' and the line "
                f"'echo \"=== job ... started ...\"'?")
        if numbers[-1] < self.stop - 1:
            raise Failure(
                f"Job {job['id']} is COMPLETED, but it only counted up to "
                f"{numbers[-1]} (STOP is {self.stop}).")
        self.restarts = max(requeued, restarts)


def main():
    if len(sys.argv) != 4 or sys.argv[1] not in ("4", "5", "6", "7", "9",
                                                  "10", "11"):
        print(__doc__, file=sys.stderr)
        return 2
    level, directory, start = int(sys.argv[1]), sys.argv[2], sys.argv[3]
    try:
        start = int(start)
    except ValueError:
        start = int(time.time()) - 24 * 3600
    checker = Checker(level, directory, start)
    try:
        if level == 9:
            checker.check_local()
        else:
            checker.check_script()
            checker.check_job()
    except Failure as e:
        print(e)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
