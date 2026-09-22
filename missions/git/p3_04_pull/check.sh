#!/bin/sh

cd "${GSH_ROOT}/World/Factory/gitlectures"

# check that we are in a clean state
if ! git status SOLDOUT_waiting_for_stock.list | grep "nothing to commit" >& /dev/null
then
    # here if file edited but not commited and/or in index
    echo "$(gettext "Looks like you have edited the file. But the change are not yet commited")"
    echo "$(gettext "Please use git status to check the status of your file.")"
    echo "$(gettext "and then use git add/git commit to create a commit")"
    false
elif ! grep -q stone SOLDOUT_waiting_for_stock.list 2> /dev/null
then
    # check that the file was edited as expected
    echo "$(gettext "Did you edit the file and create a commit?")"
    echo "$(gettext "To check the current mission, type \"gsh goal\".")"
    false
elif git status SOLDOUT_waiting_for_stock.list | grep "ahead of" >& /dev/null
then
    echo "$(gettext "It seems that you did not push your commit(s) on your git repo")"
    echo "$(gettext "Please use git status to check the current status and then use git push to publish those.")"
    false
else
    echo "$(gettext "well done")"
    true
fi
