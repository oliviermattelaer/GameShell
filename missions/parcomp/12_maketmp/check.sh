#!/usr/bin/env sh

_mission_check() (
  case "$PWD/" in
    */parcomp/*) ;;
    *) cd "$GSH_HOME/parcomp" || return 1 ;;
  esac

  if ! [ -f Makefile ]
  then
    echo "There is no file named 'Makefile' here yet."
    return 1
  fi

  if ! grep -qE '^[[:space:]]*%\.tmp[[:space:]]*:' Makefile
  then
    echo "The Makefile has no rule building '%.tmp' files."
    return 1
  fi

  if ! grep -q 'lower\.sh' Makefile
  then
    echo "The rule is there, but it never runs ./lower.sh."
    return 1
  fi

  if ! [ -f d1.tmp ]
  then
    echo "The rule looks fine, but the file 'd1.tmp' does not exist yet."
    echo "Build it with 'make d1.tmp'."
    return 1
  fi

  ref=$GSH_TMP/parcomp_d1.tmp.ref
  tr ACTG actg < d1.txt > "$ref"
  if ! cmp -s d1.tmp "$ref"
  then
    rm -f "$ref"
    echo "The file 'd1.tmp' exists but its content is not what ./lower.sh produces."
    echo "Note that ./lower.sh appends to its output file: remove 'd1.tmp' and run 'make d1.tmp' again."
    return 1
  fi
  rm -f "$ref"
  return 0
)

_mission_check
