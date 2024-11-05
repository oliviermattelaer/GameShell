#!/usr/bin/env sh

cd "$GSH_HOME"
if [ ! -e "dynamical_memory.c" ] 
then
   cp "$MISSION_DIR/dynamical_memory.c" "dynamical_memory.c"
fi
