#!/bin/sh

cd "${GSH_ROOT}/World/Factory"

# testing if ssh setup is already done
ssh -oStrictHostKeyChecking=no -T git@github.com &> $GSH_HOME/log

if cat $GSH_HOME/log | grep "successfully"
then
    echo "well done"
    rm -rf $GSH_HOME/log &> /dev/null
  true
else
    echo "error is"
    cat $GSH_HOME/log
    rm -rf $GSH_HOME/log &> /dev/null
  false
fi



