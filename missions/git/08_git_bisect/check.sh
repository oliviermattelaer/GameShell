#!/bin/sh

cd "${GSH_ROOT}/World/Factory"


if git status produce.py | grep "You are currently bisecting" >& /dev/null
then
     echo "$(gettext "git status report that you are still in bisect mode")"
     echo "$(gettext "please exit that mode with 'git bisect reset'")"
     false
else
    read -p "What is the hash number of the first bad commit? " anscommit
    git bisect start &> /dev/null
    git bisect bad HEAD~1 &> /dev/null
    git bisect good HEAD~64 &> /dev/null
    bad_commit=`git bisect run ./produce.py | grep "is the first bad commit" | awk '{print $1}'`
    git bisect reset &> /dev/null
    if [ "$bad_commit" != "$anscommit" ] ;
    then
	echo "$(gettext "Wrong this is not the bad commit")"
	echo "@$bad_commit@ @$anscommit@"
	unset goal current
	false
    else
	echo "$(gettext "Correct Well Done.")"
	echo "$(gettext "Note that a command \"git revert REV\" could be use to revert the change of the bad commit and to get a commit reverting the change done in such old commit.")"
	unset goal current
	true
    fi

fi

