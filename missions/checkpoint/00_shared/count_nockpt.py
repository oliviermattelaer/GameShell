#!/usr/bin/env python3
#
# A counter that knows nothing about checkpointing: it always starts from 0.
# DMTCP will make it restartable without changing a single line.

import time

# Last value (excluded) of the counter.
STOP = 500

for i in range(0, STOP):
    print(i, flush=True)
    time.sleep(1)
