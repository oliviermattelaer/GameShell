#!/usr/bin/env sh

_mission_check() (
  printf '%s ' "What is the 'real' duration, in seconds, of the command as reported by the time command?"
  read -r D

  case "$D" in
    1*) return 0 ;;
  esac
  echo "Are you sure? The timing should be quite low. Did you take into account the remark paragraph in the goal description?"
  return 1
)

_mission_check
