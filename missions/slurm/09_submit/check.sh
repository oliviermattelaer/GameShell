#!/usr/bin/env bash -x

JOBID=$(squeue -h --me -S i | tail -1 | awk '{print $1}')

if [[ -z $JOBID ]]
then
    echo "Cannot find your job. Make sure sbatch did not output any error."
    echo "Make sure also to run gsh check withing 90 seconds of submitting the job."
    return 1
fi


read -p "What is the job ID your job ? " JOBIDA

if [[ $JOBID == $JOBIDA ]]
then
    true
else
    echo "You might want to have a better look. Use squeue --me if you do not remember it."
    false
fi
