#!/usr/bin/env sh

# the template is not a solution
cp "$MISSION_DIR/../00_shared/count_save.py" "$GSH_HOME/Checkpoint/level2/count_save.py"
gsh assert check false

# never reads the checkpoint
cat > "$GSH_HOME/Checkpoint/level2/count_save.py" <<'END'
import time
for i in range(0, 500):
    print(i, flush=True)
    with open("checkpoint.txt", "w") as f:
        f.write(str(i))
    time.sleep(1)
END
gsh assert check false

# the solution
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
gsh assert check true
