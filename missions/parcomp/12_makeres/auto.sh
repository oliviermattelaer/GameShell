#!/usr/bin/env sh

case "$PWD/" in
  */parcomp/*) ;;
  *) cd "$GSH_HOME/parcomp" || exit 1 ;;
esac

if ! grep -qE '^[[:space:]]*%\.res[[:space:]]*:' Makefile 2>/dev/null
then
  printf '\n# Build final result\n%%.res: %%.tmp upper.sh\n\t./upper.sh $< $@\n' >> Makefile
fi
rm -f d2.tmp d2.res
make d2.res >/dev/null 2>&1

gsh check
