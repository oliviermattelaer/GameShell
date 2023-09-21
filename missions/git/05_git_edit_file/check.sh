#!/bin/sh

cd "${GSH_ROOT}/World/Factory"
if git status welcome.txt | grep "nothing to commit" >& /dev/null 
then
    if git log -1 --pretty=%B | grep "Update TODO LIST" >& /dev/null
    then
	#nothing was done not event a file change?
	echo "$(gettext "Did you edit the file and create a commit?")"
	echo "$(gettext "To check the current mission, type \"gsh goal\".")"
	unset goal current
	false	
    else
	echo "CORRECT"
	# sounds correct
	unset goal current
	true	
    fi
else
    # here if file edited but not commited and/or in index
    echo "$(gettext "Looks like you have edited the file. But the change are not yet commited")"
    echo "$(gettext "Please use git status to check the status of your file.")"
    unset goal current
    false
fi
       

