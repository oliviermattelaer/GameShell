#!/usr/bin/env sh

# the template is not a solution
cp "$MISSION_DIR/../00_shared/count_signal.py" "$GSH_HOME/Checkpoint/level3/count_signal.py"
gsh assert check false

# the solution of level 2 saves at every iteration
cat > "$GSH_HOME/Checkpoint/level3/count_signal.py" <<'END'
import time
try:
    start = int(open("checkpoint.txt").read())
except FileNotFoundError:
    start = 0
for i in range(start, 500):
    print(i, flush=True)
    with open("checkpoint.txt", "w") as f:
        f.write(str(i + 1))
    time.sleep(1)
END
gsh assert check false

# saves on SIGINT, but does not stop
cat > "$GSH_HOME/Checkpoint/level3/count_signal.py" <<'END'
import signal, time
i = 0
def handler(signum, frame):
    with open("checkpoint.txt", "w") as f:
        f.write(str(i))
signal.signal(signal.SIGINT, handler)
try:
    start = int(open("checkpoint.txt").read())
except FileNotFoundError:
    start = 0
for i in range(start, 500):
    print(i, flush=True)
    time.sleep(1)
END
gsh assert check false

# the solution
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
gsh assert check true
