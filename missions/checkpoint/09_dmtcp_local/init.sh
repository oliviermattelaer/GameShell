#!/usr/bin/env sh

_mission_init() (
  if ! command -v python3 >/dev/null
  then
    echo "The command 'python3' is required for mission $MISSION_NAME." >&2
    return 1
  fi
  [ -s "$GSH_TMP/ckpt_start_9" ] || date +%s > "$GSH_TMP/ckpt_start_9"
  dir=$GSH_HOME/Checkpoint/level9
  # don't erase the player's work when the mission is restarted
  [ -d "$dir" ] && return 0
  mkdir -p "$dir"
  cp "$MISSION_DIR/../00_shared/count_nockpt.py" "$MISSION_DIR/../00_shared/start_coordinator.sh" "$dir/"
)

# start the level in its directory
_mission_init && cd "$GSH_HOME/Checkpoint/level9"
