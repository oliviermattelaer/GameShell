#!/bin/bash
#
# ===========================================================================
# Level 6: send the signal to the submission script
# ===========================================================================
#
# With the "B:" prefix, Slurm sends the signal to the *batch script* (this
# file) instead of the job steps. Replace the --signal line with:
#
#     #SBATCH --signal=B:USR1@60
#
# Why? The script can then decide what to do: forward a signal to the
# program, copy results back, clean up, resubmit, ... (USR1 is a "user
# defined" signal: the script decides what it means.)
#
# The script must now do 3 things:
#
# 1. catch the signal with "trap":
#
#        on_signal() {
#            echo "=== signal received at $(date)"
#            # forward a Control-c to python (the job steps)
#            scancel -s SIGINT $SLURM_JOB_ID
#        }
#        trap on_signal USR1
#
#    (sending the signal to srun with "kill -INT PID" does not work: srun
#    only prints the status of the job steps on the first Control-c.)
#
# 2. start srun in the background, and wait for it:
#
#        srun python3 -u count_signal.py &
#        wait    # returns as soon as the signal arrives (after the trap)
#        wait    # wait again, for python to save and stop
#
#    Bash runs a trap only when the current *foreground* command is
#    finished. With a plain "srun python3 -u count_signal.py", the trap would
#    run only after python is finished, ie. after the end of the walltime:
#    too late! "wait" on the other hand is interrupted by signals.
#
# 3. keep the --open-mode=append and the "=== job ... started" line.
#
# ===========================================================================
#
# ===========================================================================
# Level 5: let Slurm send the signal for you
# ===========================================================================
#
# Instead of watching your job and sending the signal by hand, ask Slurm to
# send it shortly before the end of the walltime, by adding this line to the
# #SBATCH lines below:
#
#     #SBATCH --signal=SIGINT@60
#
# "SIGINT@60" means: send SIGINT 60 seconds before the walltime.
#
#  * The signal is sent to the job *steps*: python MUST be started with
#    srun, otherwise it never receives the signal, and the job is simply
#    killed at the end of the walltime (losing all the progress).
#
#  * To make this level quicker, the walltime was reduced to 70 seconds
#    (--time=00:01:10, which Slurm rounds up to 2 minutes).
#
#  * Slurm checks its timers only about once a minute: the signal may arrive
#    up to 60 seconds earlier than asked. With this walltime and @60, the
#    signal arrives 30 to 60 seconds after the start of the job.
#
#  * The delay must leave enough time to save the checkpoint: a few seconds
#    here, but it can be several minutes for a real application!
#
# Submit the job and wait: do not send any signal yourself.
#
# ===========================================================================
#
# Level 4: run the checkpointing counter (count_signal.py) on the cluster.
#
# Things to note in this script:
#
#  * --time: keep the walltime BELOW 5 MINUTES. Most clusters keep some
#    nodes for short jobs (and short jobs fill the holes of the schedule),
#    so such a job starts within seconds instead of waiting in the queue.
#
#  * --open-mode=append: by default, Slurm *empties* the output file when
#    the job starts. With "append", the new output is added at the end of
#    the file. This becomes essential when a job is restarted: you want to
#    keep the output of the previous runs.
#
#  * srun: "scancel -s SIGINT JOBID" sends the signal to the job *steps*
#    (the programs started with srun), not to this script. Without srun,
#    python would never receive the signal.
#
#  * --job-name: "gsh check" finds your job from its name, don't change it.
#
#  * the "=== job ... started" line is used by "gsh check" to find the
#    output of your job in count.out, keep it.

#SBATCH --job-name=ckpt_level4
#SBATCH --output=count.out
#SBATCH --open-mode=append
#SBATCH --signal=B:USR1@60
#SBATCH --time=00:01:10
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=100M

# Depending on the cluster, you may need to load a module to get python3:
# module load Python

echo "=== job $SLURM_JOB_ID started on $(hostname) at $(date) (restart count: ${SLURM_RESTART_COUNT:-0})"

on_signal() {
    echo "=== signal received at $(date)"
    # forward a Control-c to python (the job steps)
    scancel -s SIGINT $SLURM_JOB_ID
}
trap on_signal USR1

# the first wait is interrupted when the signal arrives, the second one
# waits for python to save its progress and stop
srun python3 -u count_signal.py &
wait
wait

echo "=== job $SLURM_JOB_ID ended at $(date)"
