#!/usr/bin/env sh

cd "$GSH_HOME"
if [ ! -e "array.c" ] 
then
   cp "$MISSION_DIR/structure.c" "structure.c"
fi
