#!/usr/bin/env sh

PART=$(sinfo -ho%P | grep \*)
echo ${PART%%\*} | gsh check
