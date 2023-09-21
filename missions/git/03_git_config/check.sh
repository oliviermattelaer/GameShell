#!/bin/sh

cd "${GSH_ROOT}/World/Factory"
if git config --get user.name
then
    unset goal current
    true
else
    echo "$(gettext "You did not setup your name correctly")"
    cd "$GSH_HOME"
    unset goal current
    false
fi

cd "${GSH_ROOT}/World/Factory"
if git config --get user.email
then
    unset goal current
    true
else
    echo "$(gettext "You did not setup your email correctly")"
    cd "$GSH_HOME"
    unset goal current
    false
fi
