#!/usr/bin/env sh

_run_count() (
  cd "$GSH_HOME/Checkpoint/level1" || exit
  python3 count.py > /dev/null 2>&1 &
  pid=$!
  sleep 2.5
  kill "$pid" 2>/dev/null
  wait
)

rm -f "$GSH_HOME/Checkpoint/level1/state"
echo 0 | gsh assert check false

# a wrong answer restarts the mission (and removes the file "state")
_run_count
echo 0 | gsh assert check false

_run_count
cat "$GSH_HOME/Checkpoint/level1/state" | gsh assert check true
unset -f _run_count
