#!/usr/bin/env sh


if [ -e dynamical_memory ]
then
    ./dynamical_memory > output
    echo "well done"
    true
else
    echo "You need to compile the code! (have a program with name dynamical_memory"
    cd "$GSH_HOME"
    false
fi
