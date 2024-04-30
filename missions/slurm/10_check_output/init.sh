#!/usr/bin/env bash

mkdir -p $GSH_HOME/testjob
[[ ! -f $GSH_HOME/testjob/submit.sh ]] && cat <<EOT  > $GSH_HOME/testjob/submit.sh
#!/bin/bash

#SBATCH --time=10:00
#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=1000MB

srun hostname
srun sleep 90
EOT

#if ! sacct | tail -1 | grep sleep &>/dev/null ; then
#sbatch --parsable $GSH_HOME/testjob/submit.sh >/dev/null
#fi
