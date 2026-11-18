#!/usr/bin/env sh

_mission_check() (
  for cmd in dmtcp_launch dmtcp_coordinator dmtcp_command dmtcp_restart
  do
    if ! command -v "$cmd" >/dev/null
    then
      echo "The command '$cmd' is not available: the DMTCP module is not loaded"
      echo "in this shell. Find its exact name (upper/lower case matters) with"
      echo "    module spider dmtcp"
      echo "and load it here with 'module load NAME'."
      return 1
    fi
  done
  return 0
)

_mission_check
