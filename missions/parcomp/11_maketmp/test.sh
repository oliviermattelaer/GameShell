#!/usr/bin/env sh

case "$PWD/" in
  */parcomp/*) ;;
  *) cd "$GSH_HOME/parcomp" || exit 1 ;;
esac

# nothing written yet
rm -f Makefile d1.tmp
gsh assert_check false

# the rule is there, but nothing has been built
printf '# Build intermediary files\n%%.tmp: %%.txt lower.sh\n\t./lower.sh $< $@\n' >> Makefile
gsh assert_check false

make d1.tmp >/dev/null 2>&1
gsh assert_check true
