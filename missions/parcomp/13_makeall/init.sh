#!/usr/bin/env sh

# restore the working copy of the sample if needed, and go there
parcomp_workdir || return 1
case "$PWD/" in
  */parcomp/*) ;;
  *) cd "$GSH_HOME/parcomp" ;;
esac

# lower.sh and upper.sh append to their output file, so timing the build only
# makes sense when nothing has been built yet: a leftover d1.tmp would make
# upper.sh read it twice over and take twice as long
rm -f ./*.tmp ./*.res

# the rules written in the two previous missions, in case the Makefile is gone
if ! [ -f Makefile ]
then
  printf '# Build intermediary files\n%%.tmp: %%.txt\n\t./lower.sh $< $@\n' >> Makefile
  printf '\n# Build final result\n%%.res: %%.tmp\n\t./upper.sh $< $@\n' >> Makefile
fi
