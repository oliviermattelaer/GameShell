# Checkpointing module: notes for instructors

GameShell version of the CISM/CÉCI hands-on "Using a Checkpoint/restart
program to overcome time limits". Levels 1-3 run anywhere with python3;
levels 4-11 must be played on the login node of a Slurm cluster (tested on
lemaitre4: Slurm 24.11, DMTCP 3.0.0, system python 3.6).

Run from the sources with

    ./start.sh missions/checkpoint/index.txt missions/FINAL_MISSION

(`FINAL_MISSION` must come last, otherwise GameShell crashes after the last
level). Each level starts in its own directory, `~/Checkpoint/levelN`.

## Time per level

Estimated for a beginner, including reading the goal and one typical mistake.
"Job" is what was measured on lemaitre4 (cluster 93% busy), from `sbatch` to
the end of the job.

| Level | Topic                                   | Beginner  | Job       |
|-------|-----------------------------------------|-----------|-----------|
| 1     | run count.py, guess the restart value   | 5 min     |           |
| 2     | write a checkpoint at every iteration   | 15 min    |           |
| 3     | checkpoint on SIGINT (signal handler)   | 20 min    |           |
| 4     | sbatch + `scancel -s SIGINT`            | 10 min    | ~1 min    |
| 5     | `--signal=SIGINT@60`                    | 10 min    | ~3 min    |
| 6     | `--signal=B:USR1@60` + trap             | 20 min    | ~3.5 min  |
| 7     | automatic requeue                       | 15-20 min | ~5.5 min  |
| 8     | `module load DMTCP`                     | 5 min     |           |
| 9     | DMTCP on the login node                 | 15 min    |           |
| 10    | DMTCP in a job, restart on login node   | 15 min    | ~1 min    |
| 11    | DMTCP + `--signal` + requeue            | 20 min    | ~6 min    |
|       | **total**                               | **~2h45** |           |

Fast participants finish in about 1h30. Levels 7 and 11 include ~2 minutes
during which the requeued job is PENDING with reason `BeginTime`: without
that delay, they are ~2 minutes shorter. The goals and `gsh check` explain
that delay, without promising a duration.

## Expected mistakes, and what `gsh check` answers

All of these were reproduced in a real game on lemaitre4.

**Level 1**
- runs `python3 Checkpoint/level1/count.py` from `~`: the `state` file is
  written in `~` → told to run it from its directory.
- answers the last number printed → told the progress is saved *after*
  printing. Answers 0 → told to look at the files. A wrong answer restarts the
  level (the `state` file is removed), so guessing doesn't work.

**Level 2** (the error messages show the player's file, not the temporary copy)
- forgets `int()` around `read()`, writes an int with `f.write(i)`, reads
  the file without handling its absence, `IndentationError`, missing
  `import os` → python's error, plus a one-line hint for each.
- opens the file with `"a"` (the file contains `012`...) → hint about
  `"w"` vs `"a"`.
- saves only after the loop → "save *inside* the loop".

**Level 3**
- no `signal.signal(...)` (KeyboardInterrupt) → told to register the handler.
- no `global interrupted` → the script never stops → hint about `global`.
- `signal.signal(signal.SIGINT, handler())`, `def handler():` without
  arguments → specific hints.
- saves in the handler but never stops; breaks but never saves; still saves
  at every iteration (level 2 code) → specific hints.

**Level 4**
- `sbatch` from the wrong directory → "a job runs where you typed sbatch".
- `scancel JOBID` without `-s` (CANCELLED), `scancel --batch -s SIGINT`
  (TIMEOUT: the signal went to the batch script) → specific hints.
- `gsh check` while the job runs → explains what to do next.
- `gsh check` right when the job ends: the files may not be visible yet on
  the login node (NFS) → the check retries for a few seconds.

**Level 5**
- `#SBATCH --signal` added after the first command, or written `# SBATCH`
  → "this line is ignored by sbatch" (before submitting).
- `@600` with a 4 minute walltime, `B:` prefix, no `srun` → caught before
  submitting.
- edits `submit.sh` and checks the old job → reminded to resubmit.

**Level 6** (all caught before submitting)
- trap but `srun` in the foreground (the trap would run too late).
- trap defined after `srun`; trap on a different signal than `--signal`.
- forwards the signal with `kill -INT` on srun (srun keeps the first
  Control-c: verified, python keeps counting and the job hits TIMEOUT).
- (a single `wait` instead of two works on lemaitre4: not reported.)

**Level 7**
- `scontrol requeue` outside the trap/`if`: the job would requeue itself
  forever → caught before submitting.
- requeue in the trap before python saved (verified: python is killed, the
  next run restarts from 0, forever) → detected while the job runs, the
  player is told to `scancel` it.
- worried that the requeued job doesn't start → `gsh check` explains
  `BeginTime`.

**Level 8**
- `module load dmtcp` (lower case) → Lmod error, and the check suggests
  `module spider dmtcp`.

**Level 9**
- `./start_coordinator.sh` instead of `. ./start_coordinator.sh` → the
  script explains the dot.
- forgets `&` → the goal explains Control-z + `bg`.
- `> count.out` instead of `>>` on restart → detected (the file no longer
  starts at 0).
- forgets to stop the restarted counter → "count.out keeps growing".
- DMTCP prints alarming `restore_brk` messages on restart: the goal sends
  them to `restart.log` and says they are normal.

**Level 10**
- `scancel -s USR1` without `--batch` (python dies, no image) → hint.
- stops the restarted counter before it printed anything → told to let it
  run a few seconds.

**Level 11**
- no "restart from the checkpoint" branch → caught before submitting.
