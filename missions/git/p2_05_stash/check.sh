#!/bin/sh

cd "${GSH_ROOT}/World/Factory"

if [[ `git rev-parse --abbrev-ref HEAD` == 'NEXTGEN' ]];
then
    echo "$(gettext "You are still in the NEXTGEN branch. To validate your change please switch to the main branch.")"
    echo "$(gettext "Note that you will not be able to switch branch if you are not in a clean state")"
    echo "$(gettext "This is why you need to use \"git stash\" to save your change and get back to a clean state")"    
    unset goal current
    false
elif ! (git status | grep "working tree clean" &> /dev/null);
then
    echo "$(gettext "Looks like you have not commited your changes. Please do so.")"
    false
elif git log -1 --pretty=%B HEAD~1 | grep  "first commit";
then
    echo "$(gettext "You either did too few (or too many) commit in the main branch. A single additional commit is expected.")"
    echo "$(gettext "What you likely need to do is to apply the difference that was save from the NEXTGEN branch.")"
    echo "$(gettext "To apply those difference to your current working directory, you can use \"git stash apply\"")"
    false
elif ! cat factory.sh | grep 11  &> /dev/null;
then
    echo "$(gettext "the state of the file factory.sh is not the expected one. Our advise is to reset the level with \"gsh reset\"")"
    false
else
    echo "$(gettext "GOOD JOB")"
    true
fi



