#!/bin/sh

cd "${GSH_ROOT}/World/Factory"

# testing if ssh setup is already done
ssh -T git@github.com &> /tmp/f

if cat /tmp/f | grep "successfully"
then
    echo "well done"
  true
else
    echo "error is"
    cat /tmp/f
  false
fi



