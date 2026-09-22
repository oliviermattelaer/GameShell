#!/bin/sh

cd "${GSH_ROOT}/World/Factory"

if gsh_github ssh
then
    echo "$(gettext "well done")"
    true
else
    echo "$(gettext "github still refuses our ssh key, the error is:")"
    ssh -T -o BatchMode=yes -o StrictHostKeyChecking=no -o ConnectTimeout=10 git@github.com 2>&1
    false
fi
