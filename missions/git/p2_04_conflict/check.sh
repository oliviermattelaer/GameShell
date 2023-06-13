#!/bin/sh

cd "${GSH_ROOT}/World/Factory"

# can use git rev-parse HEAD^2 if not exist -> merge not done...
if   git status welcome.txt | grep "You have unmerged paths." &> /dev/null;
then
     echo "$(gettext "Your merge command fail due to conflict (see gsh goal for information on what this is).")"
     echo "$(gettext "Your file welcome.txt is currently waiting for resolution (and maybe factory.sh too)")"
     echo "$(gettext "Please open that file, fix the issue, then do \"git add\" and when all conflicts are solved commit your change.")"
elif   git status factory.sh | grep "You have unmerged paths." &> /dev/null;
then
     echo "$(gettext "Your merge command fail due to conflict (see gsh goal for information on what this is).")"
     echo "$(gettext "Your file factory.sh is currently waiting for resolution")"
     echo "$(gettext "Please open that file, fix the issue, then do \"git add\" and when all conflicts are solved commit your change.")"
elif ! git diff HEAD~2 --name-only -G"<<<<<|=====|>>>>>" &>/dev/null;
then
    git diff HEAD~2 --name-only -G"<<<<<|=====|>>>>>"
    echo "$(gettext "Looks like you commited the conflict.")"
    echo "$(gettext "Please reset the level (with \"gsh reset\") and retry.")"
    echo "$(gettext "You need to edit the file welcome.txt and factory.sh to tell the code how to handle conflicting change to the same line")"
    false
elif ! git diff --cached --name-only -G"<<<<<|=====|>>>>>" &>/dev/null;
then
    git diff HEAD~2 --name-only -G"<<<<<|=====|>>>>>"
    echo "$(gettext "Looks like you commited the conflict.")"
    echo "$(gettext "Please reset the level (with \"gsh reset\") and retry.")"
    echo "$(gettext "You need to edit the file welcome.txt and factory.sh to tell the code how to handle conflicting change to the same line")"
    false    
elif   git status | grep "All conflicts fixed but you are still merging." &> /dev/null ;
then
    echo "$(gettext "Your merge command needs a \"git commit\" to be finalised.")"
    false
elif ! git rev-parse HEAD^2 &>/dev/null;
then
    echo "$(gettext "Did you forget to merge the two branches? (or did you do it by hand)?")."
    echo "$(gettext "Our advise would be to run \"git lg main NEXTGEN\" to see the status and in case reset the level with \"gsh reset\".")"
    unset goal current
    false
elif [[ `git rev-parse --abbrev-ref HEAD` == 'main' ]];
then
    echo "$(gettext "Looks like you did merge in the wrong direction. You did merge the content of 'NEXTGEN' into the main branch and not the opposite.")"
    echo "$(gettext "Did you forget to switch branch first?")"
    echo "$(gettext "We advise to reset the level with \"gsh reset\" and retry the level.")"
    unset goal current
    false
else
    echo "GOOD JOB"
    true
fi

