#!/bin/sh


if [ ! -d "$GSH_HOME/Factory" ]
then
   mkdir "$GSH_HOME/Factory"
fi

if [ -e ~/.ssh/config ]
then
    export GIT_SSH_COMMAND="ssh -F ${GSH_HOME}/.ssh/config"
fi

### SET/RESET file has expected at the end of previous mission 
if [ ! -d "$GSH_HOME/Factory/gitlectures" ]
then
    cd $GSH_HOME/Factory
    rm -rf . &> /dev/null
    if [ ! -e "$GSH_HOME/.fork" ]
    then 
       read -p "Please specify the github address of your fork:" fork
       git clone $fork gitlectures
       echo $yn > $GSH_HOME/.fork
    else
	fork=$(cat $GSH_HOME/.fork)
	git clone $fork gitlectures
    fi
    cd $GSH_HOME/Factory/gitlectures
    # check that the file is set at initial valuee
fi
fork=$(cat $GSH_HOME/.fork)


cd $GSH_HOME/Factory/gitlectures








