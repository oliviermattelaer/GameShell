#!/usr/bin/env sh

python3 -I "$MISSION_DIR/../00_shared/check_job.py" 5 "$GSH_HOME/Checkpoint/level5" "$(cat "$GSH_TMP/ckpt_start_5" 2>/dev/null)"
