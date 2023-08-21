#!/bin/sh

cd "${GSH_ROOT}/World/Factory"

# testing if ssh setup is already done
ssh -T git@github.com > /tmp/f

if $(cat /tmp/f | grep "sucessfully")
then
  true
else
  false
fi



