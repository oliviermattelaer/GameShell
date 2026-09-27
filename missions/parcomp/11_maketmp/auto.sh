#!/usr/bin/env sh

case "$PWD/" in
  */parcomp/*) ;;
  *) cd "$GSH_HOME/parcomp" || exit 1 ;;
esac

if ! grep -qE '^[[:space:]]*%\.tmp[[:space:]]*:' Makefile 2>/dev/null
then
  printf '# Build intermediary files\n%%.tmp: %%.txt lower.sh\n\t./lower.sh $< $@\n' >> Makefile
fi
rm -f d1.tmp
make d1.tmp >/dev/null 2>&1

gsh check
