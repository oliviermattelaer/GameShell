#!/usr/bin/env python3
#
# Saving the progress at *every* iteration is safe but costly: writing to disk
# can take more time than the computation itself.
# This version should save its progress only once: when it is told to stop,
# that is when it receives the signal SIGINT (what Control-c sends).
#
# Test it with
#     python3 count_signal.py
# then stop it with Control-c and start it again.

import os
import signal
import sys
import time

# Name of the file used to save the progress.
# Do NOT change it: "gsh check" looks for this file.
CHECKPOINT_FILE = "checkpoint.txt"

# Last value (excluded) of the counter: the whole computation takes about
# one minute.
STOP = 60

# Global variable telling the main loop that a signal was received.
interrupted = False

# ---------------------------------------------------------------------------
# Example: how to intercept a signal in python
#
#     def my_handler(signum, frame):
#         print("I received the signal", signum)
#
#     signal.signal(signal.SIGINT, my_handler)
#
# After the call to signal.signal(...), pressing Control-c (signal SIGINT)
# does not stop the program anymore: python calls my_handler instead, and
# then the program continues where it was.
#
# Inside a function, a global variable can be read directly, but to *modify*
# it you must first declare it:
#
#     def my_function():
#         global interrupted
#         interrupted = True
# ---------------------------------------------------------------------------

# TODO 1: write a handler for SIGINT that sets the global variable
#         "interrupted" to True, and register it with signal.signal(...).
#         Keep the handler short: it only sets the flag, the main loop does
#         the real work.


# Start from the value saved in CHECKPOINT_FILE, or from 0 if there is none
# (as in level 2).
if os.path.exists(CHECKPOINT_FILE):
    with open(CHECKPOINT_FILE) as f:
        start = int(f.read())
else:
    start = 0

i = start
for i in range(start, STOP):
    # TODO 2: if "interrupted" is True, leave the loop (break).

    print(i, flush=True)
    time.sleep(1)

# TODO 3: save the progress in CHECKPOINT_FILE. This must happen only here,
#         after the loop, NOT at every iteration.

# TODO 4: if the loop was interrupted, exit with a non zero code (sys.exit(1))
#         so that the caller knows the computation is not finished.
