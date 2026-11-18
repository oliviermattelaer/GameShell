#!/usr/bin/env python3
#
# Make this counter restartable: when it is stopped and started again, it
# must continue counting where it stopped instead of starting again from 0.
#
# Test it with
#     python3 count_save.py
# then stop it with Control-c and start it again.

import os
import time

# Name of the file used to save the progress.
# Do NOT change it: "gsh check" looks for this file.
CHECKPOINT_FILE = "checkpoint.txt"

# Last value (excluded) of the counter.
STOP = 500

# TODO 1: if CHECKPOINT_FILE exists, read the value stored in it and start
#         counting from that value. If it does not exist, start from 0.
#
#   Hints:  os.path.exists(CHECKPOINT_FILE)   is True if the file exists
#           open(CHECKPOINT_FILE).read()      returns the content (a string)
#           int("12")                         converts a string into an integer
#   (or use try: ... except FileNotFoundError: ...)
start = 0

for i in range(start, STOP):
    print(i, flush=True)

    # TODO 2: save the progress in CHECKPOINT_FILE, so that a restart
    #         continues from here.
    #
    #   Hint:   with open(CHECKPOINT_FILE, "w") as f:
    #               f.write(str(SOME_NUMBER))

    time.sleep(1)
