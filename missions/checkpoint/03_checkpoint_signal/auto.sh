#!/usr/bin/env sh

cat > "$GSH_HOME/Checkpoint/level3/count_signal.py" <<'END'
import signal
import sys
import time

CHECKPOINT_FILE = "checkpoint.txt"
STOP = 500

interrupted = False


def handler(signum, frame):
    global interrupted
    interrupted = True


signal.signal(signal.SIGINT, handler)

try:
    with open(CHECKPOINT_FILE) as f:
        start = int(f.read())
except FileNotFoundError:
    start = 0

i = start
for i in range(start, STOP):
    if interrupted:
        break
    print(i, flush=True)
    time.sleep(1)

with open(CHECKPOINT_FILE, "w") as f:
    f.write(str(i))

if interrupted:
    sys.exit(1)
END
gsh check
