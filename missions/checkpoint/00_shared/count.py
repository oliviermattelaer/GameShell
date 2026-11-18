#!/usr/bin/env python3
import time

try:
    start = int(open("state").read())
except Exception:
    start = 0

stop = 500
for i in range(start, stop):
    print(i, flush=True)
    with open("state", "w") as fsock:
        fsock.write(str(i + 1) + "\n")
    time.sleep(1)
