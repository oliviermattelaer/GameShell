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
    if [ ! -e "$GSH_HOME/.fork" ]
    then 
       read -p "Please specify the github address of your fork:" fork
       git clone $fork
       echo $fork > $GSH_HOME/.fork
    else
	fork=$(cat $GSH_HOME/.fork)
	git clone $fork
    fi
    cd $GSH_HOME/Factory/gitlectures
    # check that the file is set at initial valuee
elif [ ! -e "$GSH_HOME/.fork" ]
then
    cd $GSH_HOME/Factory/gitlectures
    fork=$(git remote get-url origin)
    echo $fork > $GSH_HOME/.fork
fi 
fork=$(cat $GSH_HOME/.fork)

### create a secondary repo for creating an out-of-sync situation
cd $GSH_HOME
git clone $fork
cd gitlectures
echo "I have succeed level 14 on `date`" >> status
git add status &> /dev/null
git commit -m "automatic push of one more commit to create out of sync" &> /dev/null
git push &> /dev/null
cd $GSH_HOME
rm -rf gitlectures



### go back to original directory:
cd $GSH_HOME/Factory/gitlectures










