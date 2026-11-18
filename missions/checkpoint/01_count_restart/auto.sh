#!/usr/bin/env sh

(
  cd "$GSH_HOME/Checkpoint/level1" || exit
  python3 count.py > /dev/null 2>&1 &
  pid=$!
  sleep 2.5
  kill "$pid" 2>/dev/null
  wait
)
cat "$GSH_HOME/Checkpoint/level1/state" | gsh check
