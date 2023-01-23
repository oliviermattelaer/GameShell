#!/bin/sh

if git status hello.txt | grep "new file" >& /dev/null
then
    unset goal current
    true
else
    echo "$(gettext "You did not add hello.txt!")"
    echo "$(gettext "You need to create a file and add it.")"
    cd "$GSH_HOME"
    unset goal current
    false
fi
