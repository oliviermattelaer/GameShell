#!/bin/sh

cd "${GSH_ROOT}/World/Factory"

nb_commit=`git log --oneline  | wc -l`

echo "nb_commit is $nb_commit (print to be removed)"
if ! `./produce.py` >& /dev/null
then
    echo "$(gettext "You did not fix the production line, the comand ./produce.py still returns 'FATAL ERROR'.")"
    echo "$(gettext "Please use gsh goal and follow the tutorial for help.")"
    unset goal current
    false
elif git status produce.py | grep "You are currently bisecting" >& /dev/null
     echo "$(gettext "git status report that you are still in bisect mode")"
     echo "$(gettext "please exit that mode with 'git bisect reset'")"
     echo "$(gettext "If you change manually produce.py to make it working, you need to ")"
     echo "$(gettext "   1. save your change to the file: 'git stash' ")"
     echo "$(gettext "   2. quit bisect mode: 'git bisect reset'  (back to last commit)")"
     echo "$(gettext "   3. apply your modification: 'git stash pop'")"    
elif git status produce.py | grep "Changes not staged for commit" >& /dev/null
then
    echo "$(gettext "Your file produce.py is still not in a clean state.")"
    echo "$(gettext "Please add/commit your change and rerun gsh check")"
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
elif [ `git log --oneline  | wc -l` -lt "68" ]; then
#    ! to test if the if works or if need to use nb_commit (if working)
else
    unset goal current
    echo "Code set as fail for check: Good Work"
    true
fi

