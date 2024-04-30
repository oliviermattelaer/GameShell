#!/usr/bin/env bash -x
#history | tail -2 | head -1 | grep "sinfo -Nl" >& /dev/null

KO=0

if ! grep -- "--time[= ]\(0-\)\?10:00\(:00\)\?" $GSH_HOME/testjob/submit.sh &>/dev/null
then
    echo "The time specification is not correct."
    KO=1
fi

if ! grep -- "--cpus-per-task[= ]4" $GSH_HOME/testjob/submit.sh &>/dev/null
then
    echo "The CPU specification is not correct."
    KO=1
fi

if ! grep -- "--mem-per-cpu[= ]1000M\?B\?" $GSH_HOME/testjob/submit.sh &>/dev/null
then
    echo "The memory specification is not correct."
    KO=1
fi

if ! grep -- "srun hostname" $GSH_HOME/testjob/submit.sh &>/dev/null
then
    echo "The hostname step is not present"
    KO=1
fi

if ! grep -- "srun sleep" $GSH_HOME/testjob/submit.sh &>/dev/null
then
    echo "The sleep step is not present"
    KO=1
fi

#TODO shoudl check that the steps are in order and they come after the resource requests

if ((KO == 1)); then
    false
else
    true
fi
