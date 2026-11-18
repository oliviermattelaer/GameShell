#!/usr/bin/env sh

python3 -I "$MISSION_DIR/../00_shared/check_job.py" 7 "$GSH_HOME/Checkpoint/level7" "$(cat "$GSH_TMP/ckpt_start_7" 2>/dev/null)"
