#!/bin/sh

cd "${GSH_ROOT}/World/Factory"

# can use git rev-parse HEAD^2 if not exist -> merge not done...
if ! git rev-parse HEAD^2 &>/dev/null; then
    echo "$(gettext "Did you forget to merge the two branches? (or did you do it by hand)?")."
    echo "$(gettext "Our advise would be to run \"git lg\" to see the status and in case reset the level with \"gsh reset\".")"
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
    true
fi

