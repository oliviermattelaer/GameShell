#!/bin/sh

cd "${GSH_ROOT}/World/Factory"

if git status produce.py | grep "Changes not staged for commit" >& /dev/null
then
    echo "$(gettext "Your file produce.py is still not in a clean state.")"
    echo "$(gettext "Did you remove the print statement that are still in your local file?")"
    echo "To discard the change that you did not put in the index. you can use 'git restore produce.py'"
    unset goal current
    false
elif git status produce.py | grep "Changes to be committed" >& /dev/null
then
    echo "$(gettext "Your file produce.py is still not in a clean state.")"
    echo "$(gettext "Please commit your changes via git commit")"
    unset goal current
    false
elif ! diff -q produce.py $MISSION_DIR/../00_git/produce_target.py &>/dev/null; then
    echo "$(gettext "not reach expected target. See below for remaining difference.")"
    diff produce.py $MISSION_DIR/../00_git/produce_target.py
    unset goal current
    false
else
    unset goal current
    echo "Code set as fail for check: Good Work"
    true
fi

