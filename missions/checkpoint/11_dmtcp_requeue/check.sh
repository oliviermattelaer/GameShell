#!/usr/bin/env sh

python3 -I "$MISSION_DIR/../00_shared/check_job.py" 11 "$GSH_HOME/Checkpoint/level11" "$(cat "$GSH_TMP/ckpt_start_11" 2>/dev/null)"
