#!/bin/sh

if [ -d .git ]
then
    unset goal current
    true
else
    echo "$(gettext "You do not have initialized a repository here!")"
    echo "$(gettext "You need to run the git init commnand")"
    cd "$GSH_HOME"
    unset goal current
    false
fi
