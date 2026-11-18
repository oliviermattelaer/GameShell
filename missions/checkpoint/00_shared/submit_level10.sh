#!/bin/bash
#
# Level 10: checkpoint a job with DMTCP.
#
# This script
#   1. starts a DMTCP coordinator on the compute node,
#   2. starts python under the control of DMTCP (dmtcp_launch),
#   3. when it receives the signal USR1: asks DMTCP to checkpoint the
#      program (save its whole memory to disk), and stops it.
#
# You send the signal yourself, to the batch script (--batch):
#     scancel --batch -s USR1 JOBID
#
# The job name and the "=== job ..." lines are used by "gsh check": keep
# them.

#SBATCH --job-name=ckpt_level10
#SBATCH --output=count.out
#SBATCH --open-mode=append
#SBATCH --time=00:04:00
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=500M

module load DMTCP

echo "=== job $SLURM_JOB_ID started on $(hostname) at $(date) (restart count: ${SLURM_RESTART_COUNT:-0})"

###############################################################################
# 1. Start a DMTCP coordinator on a free port (written in the file
#    dmtcp_command.JOBID), and set DMTCP_COORD_HOST / DMTCP_COORD_PORT so
#    that dmtcp_launch and dmtcp_command talk to it.
###############################################################################
start_coordinator()
{
    fname=dmtcp_command.$SLURM_JOB_ID
    rm -f $fname
    dmtcp_coordinator --daemon --exit-on-last -p 0 --port-file $fname "$@" > /dev/null 2>&1
    for i in $(seq 60); do
        [ -s $fname ] && break
        sleep 0.5
    done
    if ! [ -s $fname ]; then
        echo "Could not start the DMTCP coordinator."
        exit 1
    fi
    export DMTCP_COORD_HOST=$(hostname)
    export DMTCP_COORD_PORT=$(cat $fname)
    rm -f $fname
}

start_coordinator

###############################################################################
# 3. On USR1: checkpoint (--bcheckpoint waits until the checkpoint is
#    written), then stop the program and the coordinator.
###############################################################################
on_signal()
{
    echo "=== signal received at $(date): checkpointing"
    dmtcp_command --bcheckpoint
    dmtcp_command --quit
}
trap on_signal USR1

###############################################################################
# 2. Start the program under DMTCP. In the background, so that the trap can
#    run as soon as the signal arrives (see level 6).
#
#  * The output of python is redirected to count.out *inside* the job step
#    (bash -c '... >> count.out'): python then writes directly to the file,
#    in append mode, and DMTCP knows how to restore that. Without it, the
#    output goes through srun, and after a restart python would write over
#    the beginning of count.out.
#  * "10<&- 11>&-" closes two file descriptors that Slurm leaves open, which
#    DMTCP cannot checkpoint.
###############################################################################
srun bash -c 'exec dmtcp_launch --allow-file-overwrite python3 -u count_nockpt.py >> count.out' 10<&- 11>&- &
wait
wait

echo "=== job $SLURM_JOB_ID ended at $(date)"
