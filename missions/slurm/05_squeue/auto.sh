#!/usr/bin/env sh

PART=$(sinfo -ho%P | grep \*)
squeue -t PD -p ${PART%%\*} | awk '/Resources/ {print $1}' | gsh check
