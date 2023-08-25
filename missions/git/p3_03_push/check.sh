#!/bin/sh

cd "${GSH_ROOT}/World/Factory/gitlectures"
# check that we are in a clean state
if git status product.list | grep "nothing to commit" >& /dev/null 
then
    # check that the file was edited has expected
    price_line=`cat product.list | grep stone`
#    cat product.list
#    cat product.list | grep stone
    echo "price_line is $price_line"
    read -ra ADDR <<< "$price_line"
    price=${ADDR[1]}
    echo "$price ${ADDR}"
    if [[ $price == "100" ]]
    then
	echo "$(gettext "Did you edit the file and create a commit? Current price is $price")"
        echo "$(gettext "To check the current mission, type \"gsh goal\".")"
	false
    else
	if git status product.list | grep "ahead of" >& /dev/null
	then
	    echo "$(gettext "It seems that you did not push your commit(s) on your git repo")"
	    echo "$(gettext "Please use git status to check the current status and then use git push to publish those.")" 
	    false
#	elif git status product.list | grep "behind of" >& /dev/null
#	    echo "$(gettext "Looks like your local code is behind the version on github")"
#            echo "$(gettext "Please use git status to check the current status and then use git pull to sync those two.")"
#	    false
#	then
#	    false
	else
	    echo "$(gettext "well done")"
	    true
	fi
    fi
else
    # here if file edited but not commited and/or in index
    echo "$(gettext "Looks like you have edited the file. But the change are not yet commited")"
    echo "$(gettext "Please use git status to check the status of your file.")"
    echo "$(gettext "and then use git add/git commit to create a commit")"
    git status product.list | grep "nothing to commit"
    unset goal current
    false
fi
       

