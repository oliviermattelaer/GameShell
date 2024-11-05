#!/usr/bin/env sh


if [ -e hello ]
then
    true
else
    echo "$(gettext "You need to compile the code!")"
    cd "$GSH_HOME"
    false
fi
