#!/usr/bin/env sh

cd "$GSH_HOME"
if [ ! -e "structure.c" ] 
then
   cp "$MISSION_DIR/structure.c" "structure.c"
fi
