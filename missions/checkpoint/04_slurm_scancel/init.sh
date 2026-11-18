#!/usr/bin/env sh

sh "$MISSION_DIR/../00_shared/prepare_level.sh" 4 "$MISSION_DIR/../00_shared" &&
  # start the level in its directory
  cd "$GSH_HOME/Checkpoint/level4"
