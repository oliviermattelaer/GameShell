#!/usr/bin/env sh

cd "$GSH_HOME"
if [ ! -e "test_1.c" ] 
then
   cp "$MISSION_DIR/test_1.c" "test_1.c"
fi
