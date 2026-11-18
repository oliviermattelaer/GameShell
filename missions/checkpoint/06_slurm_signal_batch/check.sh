#!/usr/bin/env sh

python3 -I "$MISSION_DIR/../00_shared/check_job.py" 6 "$GSH_HOME/Checkpoint/level6" "$(cat "$GSH_TMP/ckpt_start_6" 2>/dev/null)"
