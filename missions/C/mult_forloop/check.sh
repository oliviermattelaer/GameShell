#!/usr/bin/env sh


if [ -e multiplication ]
then
    ./multiplication > output
    if ! cmp -s output $MISSION_DIR/solution
    then
        echo "the output of the code is not the same: see below:"
        diff output $MISSION_DIR/solution
        false
    else
        if grep while multiplication.c
        then
            echo 'please remove any while in your code'
        else

        echo "well done"
        true
        fi
    fi
else
    echo "$(gettext "You need to compile the code! (have a program with name multiplication")"
    cd "$GSH_HOME"
    false
fi
