#!/usr/bin/env sh

./color.py > output 2>&1
if ! diff -w output $MISSION_DIR/solution > /dev/null
then
    echo "the output of the code is not the same: see below:"
    diff output $MISSION_DIR/solution
    false
else
    echo "well done"
    true
fi
