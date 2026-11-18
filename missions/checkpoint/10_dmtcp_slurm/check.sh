#!/usr/bin/env sh

python3 -I "$MISSION_DIR/../00_shared/check_job.py" 10 "$GSH_HOME/Checkpoint/level10" "$(cat "$GSH_TMP/ckpt_start_10" 2>/dev/null)"
