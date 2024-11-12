#!/usr/bin/env sh

cd "$GSH_HOME"

if [ ! -e color.py ];
then
  cp "$MISSION_DIR/color.py" "color.py"
fi

