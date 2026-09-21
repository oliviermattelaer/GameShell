#!/usr/bin/env sh

# the goal refers to the location of the sample on a laptop, replace it with
# the actual location on this machine (e.g., the CECI clusters)
src=$(parcomp_src)
case "$src" in
  "$GSH_HOME"/*) src="~/${src#"$GSH_HOME"/}" ;;
esac
sed "s|~/training/parcomp|$src|g" "$MISSION_DIR/goal/en.txt"
unset src
