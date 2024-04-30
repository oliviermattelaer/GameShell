#!/usr/bin/env sh

mkdir -p $GSH_HOME/testjob
cat <<EOT  > $GSH_HOME/testjob/submit.sh
#!/bin/bash

#SBATCH --time=10:00
#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=1000MB

EOT

gsh check
