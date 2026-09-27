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

  if ! grep -qE '^[[:space:]]*%\.res[[:space:]]*:' Makefile
  then
    echo "The Makefile has no rule building '%.res' files."
    return 1
  fi

  if ! grep -q 'upper\.sh' Makefile
  then
    echo "The rule is there, but it never runs ./upper.sh."
    return 1
  fi

  if ! [ -f d2.res ]
  then
    echo "The rule looks fine, but the file 'd2.res' does not exist yet."
    echo "Build it with 'make d2.res'."
    return 1
  fi

  ref=$GSH_TMP/parcomp_d2.res.ref
  tr ACTG actg < d2.txt | tr actg ACTG > "$ref"
  if ! cmp -s d2.res "$ref"
  then
    rm -f "$ref"
    echo "The file 'd2.res' exists but its content is not what ./upper.sh produces."
    echo "Note that ./upper.sh appends to its output file: remove 'd2.res' and run 'make d2.res' again."
    return 1
  fi
  rm -f "$ref"
  return 0
)

_mission_check
