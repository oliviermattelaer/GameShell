#!/bin/sh

# "gsh check" runs in a subshell here, and the mission's clean.sh recreates
# the Factory directory from there: come back to it afterwards, otherwise this
# shell is left in a directory that no longer exists.
printf '1\n3\n' | gsh check
cd "$GSH_HOME/Factory"
