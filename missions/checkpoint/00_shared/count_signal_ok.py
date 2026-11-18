#!/usr/bin/env python3
#
# A counter that saves its progress only when it receives the signal SIGINT
# (Control-c), and restarts from it.
#
# (Used for the cluster levels when the script written in level 3 is not
# available.)

import os
import signal
import sys
import time

# Name of the file used to save the progress.
CHECKPOINT_FILE = "checkpoint.txt"

# Last value (excluded) of the counter.
STOP = 60

# Global variable telling the main loop that a signal was received.
interrupted = False


def handler(signum, frame):
    global interrupted
    interrupted = True


signal.signal(signal.SIGINT, handler)

# Start from the value saved in CHECKPOINT_FILE, or from 0 if there is none.
if os.path.exists(CHECKPOINT_FILE):
    with open(CHECKPOINT_FILE) as f:
        start = int(f.read())
else:
    start = 0

i = start
for i in range(start, STOP):
    if interrupted:
        break
    print(i, flush=True)
    time.sleep(1)

# Save the progress, only once, after the loop.
with open(CHECKPOINT_FILE, "w") as f:
    f.write(str(i))

# The computation is not finished: tell it to the caller.
if interrupted:
    sys.exit(1)
