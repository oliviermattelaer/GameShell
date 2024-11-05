#!/usr/bin/env sh

cd "$GSH_HOME"
if [ ! -e hello.c ];
then
  cp "$MISSION_DIR/hello.c" "hello.c"
fi
