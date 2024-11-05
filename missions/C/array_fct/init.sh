#!/usr/bin/env sh

cd "$GSH_HOME"
if [ ! -e "array.c" ] 
then
   cp "$MISSION_DIR/array.c" "array.c"
fi
