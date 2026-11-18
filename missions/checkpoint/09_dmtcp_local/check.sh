#!/usr/bin/env sh

python3 -I "$MISSION_DIR/../00_shared/check_job.py" 9 "$GSH_HOME/Checkpoint/level9" "$(cat "$GSH_TMP/ckpt_start_9" 2>/dev/null)"
