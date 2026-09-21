#!/usr/bin/env sh

_mission_check() (
  if ! [ -d "$GSH_HOME/parcomp" ]
  then
    echo "The directory is nowhere to be found!"
    return 1
  fi
  if ! [ -f "$GSH_HOME/parcomp/lower.sh" ]
  then
    echo "The directory exists, but the lower.sh script is not in it. Did you copy the whole directory?"
    return 1
  fi
  return 0
)

_mission_check
