#!/bin/sh


if [ ! -d "$GSH_HOME/Factory" ]
then
   mkdir "$GSH_HOME/Factory"
fi
   
### SET/RESET file has expected at the end of previous mission 
if [ ! -d "$GSH_HOME/Factory/gitlectures" ]
then
    cd $GSH_HOME/Factory
    if [ ! -e "$GSH_HOME/.fork" ]
    then 
       read -p "Please specify the github address of your fork:" fork
       git clone $fork
       echo $yn > $GSH_HOME/.fork
    else
	fork=$(cat $GSH_HOME/.fork)
	git clone $fork
    fi
fi

#echo "testing if ssh is correctly configured for github"
# testing if ssh setup is already done
ssh -T git@github.com 1> /tmp/f 2>&1

if cat /tmp/f | grep "successfully"
then
    echo "ssh setup already configured -> bypass level"
    false
else
    #echo "you do not have ssh configured yet (see below)"
    #cat /tmp/f
    true
fi







