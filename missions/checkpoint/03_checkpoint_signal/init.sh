#!/usr/bin/env sh

_mission_init() (
  if ! command -v python3 >/dev/null
  then
    echo "The command 'python3' is required for mission $MISSION_NAME." >&2
    return 1
  fi
  dir=$GSH_HOME/Checkpoint/level3
  mkdir -p "$dir"
  # don't erase the player's work when the mission is restarted
  [ -f "$dir/count_signal.py" ] || cp "$MISSION_DIR/../00_shared/count_signal.py" "$dir/"
)

# start the level in its directory
_mission_init && cd "$GSH_HOME/Checkpoint/level3"
