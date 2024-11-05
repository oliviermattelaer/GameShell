#!/usr/bin/env sh

cd "$GSH_HOME"
if [ ! -e "test_1.c" ] 
then
   cp "$MISSION_DIR/test_1.c" "test_1.c"
fi
if [ ! -e "test_2.c" ] 
then
   cp "$MISSION_DIR/test_2.c" "test_2.c"
fi
