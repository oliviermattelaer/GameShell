#!/usr/bin/env sh

_mission_check() (
  if ! [ -f "${PARALLEL_HOME:-$HOME/.parallel}/will-cite" ]
  then
    echo "Have you run parallel --citation? It seems not."
    return 1
  fi
  return 0
)

_mission_check
