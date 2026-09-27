#!/usr/bin/env sh

case "$PWD/" in
  */parcomp/*) ;;
  *) cd "$GSH_HOME/parcomp" || exit 1 ;;
esac

# without the "all" target, no answer can be right
echo 8.05 | gsh assert_check false

if ! grep -qE '^[[:space:]]*all[[:space:]]*:' Makefile 2>/dev/null
then
  { printf '# Build everything\nall: d1.res d2.res d3.res d4.res\n\n'; cat Makefile; } > Makefile.new
  mv Makefile.new Makefile
fi

echo 12.1 | gsh assert_check false
echo 32 | gsh assert_check false
echo 8.05 | gsh assert_check true
