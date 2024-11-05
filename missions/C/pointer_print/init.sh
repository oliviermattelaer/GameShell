#!/usr/bin/env sh

cd "$GSH_HOME"
if [ ! -e "address.c" ] 
then
   cp "$MISSION_DIR/address.c" "address.c"
fi
