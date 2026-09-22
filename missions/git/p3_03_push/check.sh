#!/bin/sh

cd "${GSH_ROOT}/World/Factory/gitlectures"

# check that we are in a clean state
if ! git status product.list | grep "nothing to commit" >& /dev/null
then
    # here if file edited but not commited and/or in index
    echo "$(gettext "Looks like you have edited the file. But the change are not yet commited")"
    echo "$(gettext "Please use git status to check the status of your file.")"
    echo "$(gettext "and then use git add/git commit to create a commit")"
    false
elif [ "$(awk '/stone/ {print $2}' product.list 2> /dev/null)" = "100" ]
then
    # check that the file was edited as expected
    echo "$(gettext "Did you edit the file and create a commit? The price of the philosopher's stone did not change.")"
    echo "$(gettext "To check the current mission, type \"gsh goal\".")"
    false
elif git status product.list | grep "ahead of" >& /dev/null
then
    echo "$(gettext "It seems that you did not push your commit(s) on your git repo")"
    echo "$(gettext "Please use git status to check the current status and then use git push to publish those.")"
    false
else
    echo "$(gettext "well done")"
    true
fi
