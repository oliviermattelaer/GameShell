#!/usr/bin/env sh

cd "$GSH_HOME"
if [ ! -e "multiplication.c" ] 
then
   cp "$MISSION_DIR/multiplication.c" "multiplication.c"
fi
