#!/usr/bin/env sh


if [ -e address ]
then
     ./address > output
     echo "well done"
     true
else
    echo "You need to compile the code! (have a program with name address"
    cd "$GSH_HOME"
    false
fi
