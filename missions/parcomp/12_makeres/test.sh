#!/usr/bin/env sh

case "$PWD/" in
  */parcomp/*) ;;
  *) cd "$GSH_HOME/parcomp" || exit 1 ;;
esac

# only the rule of the previous mission
gsh assert_check false

# the second rule is there, but nothing has been built
printf '\n# Build final result\n%%.res: %%.tmp\n\t./upper.sh $< $@\n' >> Makefile
gsh assert_check false

rm -f d2.tmp d2.res
make d2.res >/dev/null 2>&1
gsh assert_check true
