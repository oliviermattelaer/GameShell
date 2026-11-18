#!/usr/bin/env sh

cat > "$GSH_HOME/Checkpoint/level2/count_save.py" <<'END'
import time

CHECKPOINT_FILE = "checkpoint.txt"
STOP = 500

try:
    with open(CHECKPOINT_FILE) as f:
        start = int(f.read())
except FileNotFoundError:
    start = 0

for i in range(start, STOP):
    print(i, flush=True)
    with open(CHECKPOINT_FILE, "w") as f:
        f.write(str(i + 1))
    time.sleep(1)
END
gsh check
