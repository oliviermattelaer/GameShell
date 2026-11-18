#!/usr/bin/env sh

_mission_init() (
  if ! command -v python3 >/dev/null
  then
    echo "The command 'python3' is required for mission $MISSION_NAME." >&2
    return 1
  fi
  dir=$GSH_HOME/Checkpoint/level1
  mkdir -p "$dir"
  cp "$MISSION_DIR/../00_shared/count.py" "$dir/"
  rm -f "$dir/state"
)

# start the level in its directory
_mission_init && cd "$GSH_HOME/Checkpoint/level1"
