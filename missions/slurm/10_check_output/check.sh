#!/usr/bin/env bash 

WORKERID=$(sacct -X -n --user $USER -o jobid,nodelist | sort -n | tail -1 | awk '{print $2}')

if [[ -z $WORKERID ]]
then
    echo "Cannot find your job. Make sure sbatch did not output any error."
    return 1
fi

read -p "Who is the worker that took care of your job ? " WORKERIDA

if [[ $WORKERIDA == $WORKERID* ]]
then
    true
else
    echo "You might want to have a better look. Maybe you are looking at an older job?"
    false
fi
