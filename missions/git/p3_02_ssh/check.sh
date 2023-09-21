#!/bin/sh

cd "${GSH_ROOT}/World/Factory"

if [ -e ~/.ssh/config ]
then
    export SSH_CONFIG="-F ${GSH_HOME}/.ssh/config"
    export GIT_SSH_COMMAND="ssh -F ${GSH_HOME}/.ssh/config"
fi

# testing if ssh setup is already done
ssh -oStrictHostKeyChecking=no -T git@github.com ${SSH_CONFIG} &> $GSH_HOME/log

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



