#!/usr/bin/env sh

_mission_check() (
  printf "If you stop count.py and run it again, which number will it print first? "
  read -r answer
  answer=$(echo "$answer" | tr -d ' ')
  case $answer in
    0)
      return 0
      ;;
    ''|*[!0-9]*)
      echo "Answer with a single number."
      ;;
    *)
      echo "No. Don't guess: run count.py, stop it with Control-c, and run it"
      echo "again to see where it starts."
      ;;
  esac
  return 1
)

_mission_check
