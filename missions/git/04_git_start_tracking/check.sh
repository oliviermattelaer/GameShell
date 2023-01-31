#!/bin/sh


cd "${GSH_ROOT}/World/Factory"
if git status welcome.txt | grep "new file" >& /dev/null
then
    echo "$(gettext "Looks like you did start to track the file but git does not have store a copy yet.")"
    echo "$(gettext "You need to commit your change.")"
    cd "$GSH_HOME/Factory"
    #unset goal current
    false
else
    if git status welcome.txt | grep "working tree clean" >& /dev/null
    then
	if [ -e welcome.txt ]
	then
	   unset goal current
	   true
	else
	    echo "$(gettext "Why we do not have the file welcome.txt. Please run gsh reset to retry the level")"
	    unset goal current
	    false
	fi
    else	
       echo "$(gettext "If you are confused always start by running git status, it will typically help you")"
       cd "$GSH_HOME/Factory"
    unset goal current
    false
    fi
fi
