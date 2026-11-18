#!/usr/bin/env sh

_mission_check() (
  python3 -I "$MISSION_DIR/../00_shared/check_count.py" signal "$GSH_HOME/Checkpoint/level3/count_signal.py" "~/Checkpoint/level3/count_signal.py"
)

_mission_check
