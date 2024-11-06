#!/usr/bin/env sh


if [ -e multiplication ]
then
    ./multiplication > output
    if ! diff -w output $MISSION_DIR/solution > /dev/null
    then
        echo "the output of the code is not the same: see below:"
        diff output $MISSION_DIR/solution
        false
    else
        echo "well done"
        true
    fi
else
    echo "$(gettext "You need to compile the code! (have a program with name multiplication")"
    cd "$GSH_HOME"
    false
fi
