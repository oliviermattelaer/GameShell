#!/usr/bin/env sh

python3 -I "$MISSION_DIR/../00_shared/check_job.py" 4 "$GSH_HOME/Checkpoint/level4" "$(cat "$GSH_TMP/ckpt_start_4" 2>/dev/null)"
