#!/bin/sh


cd "${GSH_ROOT}/World/Factory"
if git status welcome.txt | grep "new file" >& /dev/null
then
    echo "$(gettext "Looks like you did start to track the file but git does not have store a copy yet.")"
    echo "$(gettext "You need to commit your change.")"
    #cd "$GSH_HOME/Factory"
    unset goal current
    false
else
    if git status welcome.txt | grep "nothing to commit" >& /dev/null
    then
	if [ -e welcome.txt ]
	then
	    commit=$(git log -1 --pretty=%B)
	    if (( ${#commit} < 5 ))
	    then 
		echo "$(gettext "It is important to set informative commit message. Please change your commit message via the command")"
		echo  "$(gettext "git commit --amend -m \"a message like, adding file welcome.txt\"")"
	       unset goal current commit
	       false
	    else
		unset goal current commit
		true
	    fi
	else
	    echo "$(gettext "Why we do not have the file welcome.txt. Please run gsh reset to retry the level")"
	    unset goal current
	    false
	fi
    else	
       echo "$(gettext "If you are confused: always start by running git status, it will typically help you")"
       cd "$GSH_HOME/Factory"
    unset goal current
    false
    fi
fi
