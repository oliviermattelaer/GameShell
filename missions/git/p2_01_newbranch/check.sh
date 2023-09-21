#!/bin/sh

cd "${GSH_ROOT}/World/Factory"

curr_branch=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
### CHECK BRANCH
if [[ "$curr_branch" == "main" ]]
then
    echo "$(gettext "You are still in the main branch.")"
    echo "$(gettext "To create (and change branch) you can use git switch -c NAME.")"
    unset goal current curr_branch
    false
elif [[ "$curr_branch" != "NEXTGEN" ]]
then
    echo "$(gettext "Your branch name is $curr_branch instead of the expected NEXTGEN.")"
    echo "$(gettext "You can choose one of the following options:")"
    echo "$(gettext "   - use \"gsh reset\" to reset the level.")"
    echo "$(gettext "   - use \"git branch -m OLDNAME NEWNAME\" to simply change the name of the branch .")"
    echo "$(gettext "   - use \"git switch -c NEXTGEN\" to simply create a new branch (and leave this one as it is) .")"
    unset goal current curr_branch
    false
### CHECK THAT FILE IS IN CLEAN STATE
elif git status welcome.txt | grep "Changes not staged for commit" >& /dev/null
then
    echo "$(gettext "Your file welcome.txt has not been staged/commited.")"
    unset goal current curr_branch
    false
elif git status welcome.txt | grep "Changes to be committed" >& /dev/null
then
    echo "$(gettext "Your file welcome.txt is still not in a clean state (it is not committed).")"
    echo "$(gettext "Please commit your changes via git commit")"
    unset goal current curr_branch
    false
### CHECK CONTENT OF THE FILE
elif grep "Factory v1.0 " welcome.txt >& /dev/null
then
    echo "$(gettext "Did you edit the file welcome.txt? It does not contain the correct version information.")"
    echo "$(gettext " Remember that you can reset (and retry) the level by running \"gsh reset\"")"
    unset goal current curr_branch
    false
else
    unset goal current curr_branch
    echo "Good Work"
    true
fi

