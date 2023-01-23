#!/bin/sh


cd "${GSH_ROOT}/World/Factory"
if git status hello.txt | grep "new file" >& /dev/null
then
    unset goal current
    true
else
    echo "$(gettext "You did not add hello.txt!")"
    echo "$(gettext "You need to create a file and add it.")"
    cd "$GSH_HOME/Factory"
    unset goal current
    false
fi
