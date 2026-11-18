#!/usr/bin/env python3
"""Check the player's counter for the local levels of the checkpoint missions.

usage: check_count.py save|signal SCRIPT [DISPLAY_NAME]

  save    (level 2) the script saves its progress at every iteration
  signal  (level 3) the script saves its progress only when it receives SIGINT

The script is run in a temporary directory, so the player's own checkpoint
file is never touched. DISPLAY_NAME is how the script is called in the
messages (default: SCRIPT). Exit code 0 means the mission is validated.

The messages are meant for beginners: whenever possible, they say what is
probably wrong in the script, not only what the test observed.
"""

import os
import random
import re
import shutil
import signal
import subprocess
import sys
import tempfile
import time

CHECKPOINT = "checkpoint.txt"
# The counter prints a number every second: after 2.5 seconds it has printed
# 0, 1 and 2 and is sleeping.
WAIT = 2.5
# Time given to the script to save and stop after SIGINT.
GRACE = 3

# Python errors a beginner is likely to meet, and what to do about them.
# (pattern in the error messages, hint)
ERROR_HINTS = [
    (r"FileNotFoundError.*" + re.escape(CHECKPOINT),
     f"Your script crashes when '{CHECKPOINT}' doesn't exist (the very "
     f"first run). In that case it must start from 0: test whether the file "
     f"exists with os.path.exists({CHECKPOINT!r}) before reading it, or use "
     f"try: ... except FileNotFoundError: ..."),
    (r"'str' object cannot be interpreted as an integer"
     r"|can only concatenate str|unsupported operand type\(s\).*'str'",
     "open(...).read() returns a *string* (some text), not a number: "
     "convert it with int(...), for instance "
     "start = int(open(CHECKPOINT_FILE).read())"),
    (r"write\(\) argument must be str",
     "f.write(...) only writes strings: convert the number first, for "
     "instance f.write(str(i))"),
    (r"invalid literal for int\(\)",
     f"int(...) could not convert the content of '{CHECKPOINT}' into a "
     f"number: write only the number in the file, for instance "
     f"f.write(str(i))."),
    (r"name 'os' is not defined", "Add 'import os' at the top of the script."),
    (r"name 'sys' is not defined",
     "Add 'import sys' at the top of the script."),
    (r"name 'signal' is not defined",
     "Add 'import signal' at the top of the script."),
    (r"IndentationError|TabError",
     "Python could not read your script because of the indentation (the "
     "spaces at the beginning of the lines), at the line shown above. The "
     "lines inside an 'if', a 'for', a 'with' or a 'def' must all be "
     "indented by the same number of spaces (4 is customary), and don't mix "
     "tabs and spaces."),
    (r"SyntaxError",
     "Python could not read your script: look at the line shown above "
     "(a missing ':' at the end of an if/for/def line, or a missing "
     "parenthesis, is common)."),
    (r"signal handler must be|handler\(\) missing 2 required positional",
     "Give signal.signal the handler function itself, without "
     "parentheses: signal.signal(signal.SIGINT, my_handler). With "
     "my_handler() you call the function, and pass what it returns."),
    (r"takes 0 positional arguments but 2 were given",
     "A signal handler receives two arguments: define it as "
     "def my_handler(signum, frame):"),
    (r"local variable '\w+' referenced before assignment"
     r"|cannot access local variable",
     "To modify a global variable inside a function, declare it first, "
     "for instance 'global interrupted' as the first line of the handler."),
    (r"KeyboardInterrupt",
     "The signal SIGINT (Control-c) was not intercepted: python stopped the "
     "script with a KeyboardInterrupt error. Register your handler with "
     "signal.signal(signal.SIGINT, my_handler) before the loop."),
    (r"NameError",
     "A name used in your script is not defined: check its spelling "
     "(python is case sensitive) and that it is defined before being used."),
]


class Failure(Exception):
    pass


class Script:
    """The player's script: its source, and how to name it in messages."""

    def __init__(self, path, display):
        self.path = path
        self.display = display
        with open(path, errors="replace") as f:
            self.source = f.read()
        # the code without the comments, for the heuristics
        self.code = "\n".join(line.split("#", 1)[0]
                              for line in self.source.splitlines())

    def has(self, pattern):
        return re.search(pattern, self.code, re.MULTILINE) is not None

    def writes_checkpoint(self):
        return self.has(r"open\([^)]*['\"][wa]")

    def write_in_loop(self):
        """Is there a write to a file inside the for loop?"""
        lines = self.code.splitlines()
        for n, line in enumerate(lines):
            m = re.match(r"^(\s*)for\b", line)
            if not m:
                continue
            indent = len(m.group(1))
            for body in lines[n + 1:]:
                if not body.strip():
                    continue
                if len(body) - len(body.lstrip()) <= indent:
                    break
                if re.search(r"open\([^)]*['\"][wa]|\.write\(", body):
                    return True
        return False


class Run:
    """The player's script, running in the background in WORKDIR."""

    def __init__(self, script, workdir, tag):
        self.script = script
        self.workdir = workdir
        self.out = os.path.join(workdir, ".{}.out".format(tag))
        self.err = os.path.join(workdir, ".{}.err".format(tag))
        with open(self.out, "w") as out, open(self.err, "w") as err:
            self.proc = subprocess.Popen(
                [sys.executable, "-u", script.path],
                cwd=workdir,
                stdin=subprocess.DEVNULL,
                stdout=out,
                stderr=err,
                start_new_session=True,
                # a shell may have started us with SIGINT ignored
                preexec_fn=lambda: signal.signal(signal.SIGINT, signal.SIG_DFL),
            )
        time.sleep(WAIT)

    def alive(self):
        return self.proc.poll() is None

    def numbers(self):
        nums = []
        with open(self.out) as f:
            for line in f:
                try:
                    nums.append(int(line.strip()))
                except ValueError:
                    pass
        return nums

    def interrupt(self):
        """Send SIGINT, return True if the script stopped in time."""
        self.proc.send_signal(signal.SIGINT)
        try:
            self.proc.wait(GRACE)
            return True
        except subprocess.TimeoutExpired:
            self.kill()
            return False

    def kill(self):
        if self.alive():
            self.proc.kill()
        self.proc.wait()

    def errors(self):
        """The error messages of the script, with a hint for beginners."""
        try:
            with open(self.err, errors="replace") as f:
                text = f.read()
        except OSError:
            return ""
        if not text.strip():
            return ""
        # show the player's file, not the temporary copy
        text = text.replace(self.script.path, self.script.display)
        lines = text.splitlines()[-8:]
        msg = "\n\nError messages of your script:\n"
        msg += "\n".join("    " + line for line in lines)
        for pattern, hint in ERROR_HINTS:
            if re.search(pattern, text):
                msg += "\n\nHint: " + hint
                break
        return msg


def checkpoint_path(workdir):
    return os.path.join(workdir, CHECKPOINT)


def read_checkpoint(workdir, when, extra=""):
    path = checkpoint_path(workdir)
    if not os.path.exists(path):
        others = sorted(f for f in os.listdir(workdir) if not f.startswith("."))
        others = [f for f in others if not f.endswith(".py")]
        hint = ""
        if others:
            hint = ("\nI found these files instead: {}. Keep the name '{}' "
                    "(CHECKPOINT_FILE) for the checkpoint file."
                    .format(", ".join(others), CHECKPOINT))
        raise Failure("The file '{}' was not created {}.{}{}"
                      .format(CHECKPOINT, when, hint, extra))
    with open(path) as f:
        content = f.read().strip()
    try:
        return int(content)
    except ValueError:
        raise Failure(
            "The file '{}' should contain a single number, but it contains "
            "'{}'.\nWrite only the number, for instance f.write(str(i))."
            .format(CHECKPOINT, content[:40]))


def check_value(value, nums, when):
    """The saved value must be the last number printed, or the next one."""
    if not nums:
        return
    last = nums[-1]
    if value in (last - 1, last, last + 1):
        return
    msg = ("{}, your script had printed up to {}, but the file '{}' "
           "contains {}.\nIt should contain the value where the counter "
           "must restart ({} or {})."
           .format(when, last, CHECKPOINT, value, last, last + 1))
    digits = "".join(str(n) for n in nums)
    if len(str(value)) > len(str(last)) + 1 or str(value) in digits:
        msg += ("\n\nHint: it looks like the numbers are added at the end of "
                "the file, one after the other. Open the file with \"w\" "
                "(write: replaces the content), not with \"a\" (append).")
    raise Failure(msg)


def check_start(run, expected, why):
    nums = run.numbers()
    if not nums:
        run.kill()
        raise Failure("Your script printed nothing {}.{}"
                      .format(why, run.errors()))
    first = nums[0]
    if first not in expected:
        run.kill()
        if expected[0] != 0 and first == 0:
            raise Failure(
                "When the file '{}' contains {}, your script still starts "
                "again from 0: it does not use the saved value.\n\nHint: "
                "read the file at the beginning of the script, and use its "
                "value as the start of the range(...) of the loop."
                .format(CHECKPOINT, expected[0]))
        raise Failure(
            "{}{}, your script should start counting from {}, but it printed "
            "{} first.".format(why[0].upper(), why[1:], expected[0], first))
    if not run.alive():
        raise Failure(
            "Your script stopped by itself {}, after printing {}. It should "
            "keep counting.{}".format(why, nums[-1], run.errors()))
    return nums


def check_save(script, workdir):
    print("Test 1: no checkpoint file, the counter must start from 0...")
    run = Run(script, workdir, "run1")
    nums = check_start(run, (0,), "when there is no checkpoint file")
    run.kill()
    print("Test 2: the checkpoint file must be created...")
    hint = ""
    if not script.writes_checkpoint():
        hint = ("\n\nHint: your script never opens a file for writing: "
                "complete TODO 2.")
    elif not script.write_in_loop():
        hint = ("\n\nHint: the progress must be saved *inside* the loop, at "
                "every iteration: if the program is killed, the code after "
                "the loop is never run.")
    value = read_checkpoint(workdir, "while your script was counting", hint)
    check_value(value, nums, "When it was stopped")

    print("Test 3: the counter must restart from the checkpoint file...")
    start = random.randint(20, 40)
    with open(checkpoint_path(workdir), "w") as f:
        f.write("{}\n".format(start))
    run = Run(script, workdir, "run2")
    nums = check_start(run, (start, start + 1),
                       "when the file '{}' contains {}".format(CHECKPOINT,
                                                               start))
    run.kill()
    value = read_checkpoint(workdir, "by the second run")
    check_value(value, nums, "When it was stopped")


def not_stopped(script, workdir):
    msg = ("Your script was still running {} seconds after receiving SIGINT "
           "(Control-c). After saving its progress, it must stop.\n(When "
           "you test it yourself and Control-c doesn't stop it, use "
           "Control-\\ instead: it sends another signal, SIGQUIT.)"
           .format(GRACE))
    if os.path.exists(checkpoint_path(workdir)):
        msg += ("\n\nHint: your script saved its progress, but then kept "
                "counting. Let the handler only set the global variable "
                "'interrupted', and let the main loop stop ('break') when it "
                "is True.")
    elif script.has(r"def\s+\w+\s*\(") and not script.has(r"\bglobal\b"):
        msg += ("\n\nHint: your handler probably sets a *local* variable "
                "called 'interrupted', which disappears when the handler "
                "returns: the main loop never sees it. Declare it global at "
                "the beginning of the handler:\n"
                "    def my_handler(signum, frame):\n"
                "        global interrupted\n"
                "        interrupted = True")
    elif not script.has(r"\bbreak\b|sys\.exit|exit\("):
        msg += ("\n\nHint: when 'interrupted' is True, leave the loop with "
                "'break' (TODO 2).")
    return Failure(msg)


def missing_after_signal(script, run):
    hint = run.errors()
    if not hint:
        if not script.writes_checkpoint():
            hint = ("\n\nHint: your script never opens a file for writing: "
                    "save the progress after the loop (TODO 3).")
        else:
            hint = ("\n\nHint: is the code saving the progress really run "
                    "after the loop is interrupted? (It must not be inside "
                    "the loop, nor inside an 'if' that is never true.)")
    return hint


def check_signal(script, workdir):
    print("Test 1: no checkpoint file, the counter must start from 0...")
    run = Run(script, workdir, "run1")
    nums = check_start(run, (0,), "when there is no checkpoint file")
    if os.path.exists(checkpoint_path(workdir)):
        run.kill()
        raise Failure(
            "Your script wrote the file '{}' before receiving any signal. It "
            "must only save its progress when it receives SIGINT.\n\nHint: "
            "remove the code that saves the progress from the loop (that was "
            "level 2), and save it once, after the loop.".format(CHECKPOINT))
    print("Test 2: after Control-c, the checkpoint file must be written...")
    if not run.interrupt():
        raise not_stopped(script, workdir)
    nums = run.numbers()
    value = read_checkpoint(workdir, "after Control-c",
                            missing_after_signal(script, run))
    check_value(value, nums, "When it received Control-c")

    print("Test 3: restart from the checkpoint file, save again on "
          "Control-c...")
    start = random.randint(20, 40)
    path = checkpoint_path(workdir)
    with open(path, "w") as f:
        f.write("{}\n".format(start))
    before = os.stat(path).st_mtime_ns
    # make sure a rewrite changes the modification time
    time.sleep(0.05)
    run = Run(script, workdir, "run2")
    nums = check_start(run, (start, start + 1),
                       "when the file '{}' contains {}".format(CHECKPOINT,
                                                               start))
    if not os.path.exists(path) or os.stat(path).st_mtime_ns != before:
        run.kill()
        raise Failure(
            "Your script modified the file '{}' before receiving any signal. "
            "It must only save its progress when it receives SIGINT."
            .format(CHECKPOINT))
    if not run.interrupt():
        raise not_stopped(script, workdir)
    nums = run.numbers()
    value = read_checkpoint(workdir, "after Control-c",
                            missing_after_signal(script, run))
    if value == start:
        raise Failure(
            "After Control-c, the file '{}' still contains {}: your script "
            "did not save its new progress.".format(CHECKPOINT, start))
    check_value(value, nums, "When it received Control-c")


def main():
    if len(sys.argv) not in (3, 4) or sys.argv[1] not in ("save", "signal"):
        print(__doc__, file=sys.stderr)
        return 2
    mode, path = sys.argv[1], sys.argv[2]
    display = sys.argv[3] if len(sys.argv) == 4 else path
    if not os.path.isfile(path):
        print("The file '{}' does not exist anymore!".format(display))
        return 1
    print("Testing your script, this takes a few seconds.")
    workdir = tempfile.mkdtemp(prefix="gsh-checkpoint-")
    try:
        local = os.path.join(workdir, os.path.basename(path))
        shutil.copy(path, local)
        script = Script(local, display)
        if mode == "save":
            check_save(script, workdir)
        else:
            check_signal(script, workdir)
    except Failure as e:
        print()
        print(e)
        return 1
    finally:
        shutil.rmtree(workdir, ignore_errors=True)
    return 0


if __name__ == "__main__":
    sys.exit(main())
