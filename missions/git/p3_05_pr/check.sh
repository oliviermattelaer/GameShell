#!/bin/sh

cd "${GSH_ROOT}/World/Factory/gitlectures"
# check that we are in a clean state
if git status SOLDOUT_waiting_for_stock.list | grep "nothing to commit" >& /dev/null 
then
    # check that the file was edited has expected
    price_line=$(cat SOLDOUT_waiting_for_stock.list | grep excalibur -i)
#    echo "price_line is at !$price_line!"
#    read -ra ADDR <<< "$price_line"
#    price=${ADDR[1]}
    if [[ $price_line != "" ]]
    then
	echo "$(gettext "Check the comment on your Pull Request for instructions on how to finish the level")"
#        echo "$(gettext "To check the current mission, type \"gsh goal\".")"
	false
    else
	if git status SOLDOUT_waiting_for_stock.list | grep "ahead of" >& /dev/null
	then
	    echo "$(gettext "It seems that you did not push your commit(s) on your git repo")"
	    echo "$(gettext "Please use git status to check the current status and then use git push to publish those.")" 
	    false
#	elif git status product.list | grep "ahead of" >& /dev/null
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
    unset goal current
    false
fi
       

