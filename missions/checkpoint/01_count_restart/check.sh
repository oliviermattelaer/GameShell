#!/usr/bin/env sh

_mission_check() (
  dir=$GSH_HOME/Checkpoint/level1
  if ! [ -f "$dir/state" ]
  then
    # count.py writes "state" in the *current* directory: if it was run from
    # elsewhere, the file is there
    elsewhere=$(find "$GSH_HOME" -name state -type f 2>/dev/null | head -n 1)
    if [ -n "$elsewhere" ]
    then
      echo "count.py saves its progress in the file \"state\" of the directory"
      from=$(dirname "$elsewhere")
      from="~${from#"$GSH_HOME"}"
      echo "where you run it. You ran it from $from, not from"
      echo "~/Checkpoint/level1. Go to that directory first:"
      echo "    cd ~/Checkpoint/level1"
      echo "    python3 count.py"
      rm -f "$elsewhere"
    else
      echo "Run count.py first:"
      echo "    cd ~/Checkpoint/level1"
      echo "    python3 count.py"
      echo "and stop it with Control-c after a few numbers."
    fi
    return 1
  fi
  expected=$(cat "$dir/state")

  printf "If you run count.py again, which number will it print first? "
  read -r answer
  answer=$(echo "$answer" | tr -d ' ')
  if [ "$answer" = "$expected" ]
  then
    return 0
  fi
  case $answer in
    ''|*[!0-9]*)
      echo "Answer with a single number."
      ;;
    0)
      echo "No: it would start again from 0 if it didn't remember anything."
      echo "Look at the files in ~/Checkpoint/level1: count.py left something there."
      ;;
    $((expected - 1)))
      echo "No: that's the last number it printed, but count.py saved its"
      echo "progress just after printing it. Look at the files in"
      echo "~/Checkpoint/level1, and at the code of count.py."
      ;;
    *)
      echo "No. Look at the files in ~/Checkpoint/level1, and at the code of count.py."
      ;;
  esac
  echo "(Run count.py again, and stop it, before you retry.)"
  return 1
)

_mission_check
