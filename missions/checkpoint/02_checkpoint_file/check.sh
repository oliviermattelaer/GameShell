#!/usr/bin/env sh

_mission_check() (
  python3 -I "$MISSION_DIR/../00_shared/check_count.py" save "$GSH_HOME/Checkpoint/level2/count_save.py" "~/Checkpoint/level2/count_save.py"
)

_mission_check
