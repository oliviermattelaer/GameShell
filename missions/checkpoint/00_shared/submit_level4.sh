#!/bin/bash
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
#SBATCH --time=00:04:00
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=100M

# Depending on the cluster, you may need to load a module to get python3:
# module load Python

echo "=== job $SLURM_JOB_ID started on $(hostname) at $(date) (restart count: ${SLURM_RESTART_COUNT:-0})"

srun python3 -u count_signal.py

echo "=== job $SLURM_JOB_ID ended at $(date)"
