#!/usr/bin/env sh

# restore the working copy of the sample if needed, and go there
parcomp_workdir || return 1
case "$PWD/" in
  */parcomp/*) ;;
  *) cd "$GSH_HOME/parcomp" || return 1 ;;
esac

# the rule written in the previous mission, in case the Makefile is gone
if ! grep -qE '^[[:space:]]*%\.tmp[[:space:]]*:' Makefile 2>/dev/null
then
  printf '# Build intermediary files\n%%.tmp: %%.txt\n\t./lower.sh $< $@\n' >> Makefile
fi
