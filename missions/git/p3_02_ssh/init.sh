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
ssh -oStrictHostKeyChecking=no -T git@github.com 1> $GSH_HOME/log 2>&1

if cat $GSH_HOME/log | grep "successfully"
then
    echo "ssh setup already configured"
    echo "LEVEL is an autowin."
    echo "Please run gsh check to go to next level"
    rm -rf $GSH_HOME/log &> /dev/null
    #cp "$MISSION_DIR/setup_ssh.sh" "$GSH_HOME/Factory/gitlectures/setup_ssh"
    #chmod +x $GSH_HOME/Factory/gitlectures/setup_ssh
    false
#    if $(gsh check &> /dev/null)
#    then
#       $MISSION_DIR/treasure.sh
#       true
#    fi
else
    #echo "you do not have ssh configured yet (see below)"
    # cat $GSH_HOME/log
    rm -rf $GSH_HOME/log &> /dev/null
    cp "$MISSION_DIR//setup_ssh.sh" "$GSH_HOME/Factory/gitlectures/setup_ssh"
    chmod +x $GSH_HOME/Factory/gitlectures/setup_ssh 
    
    true
fi

cd $GSH_HOME/Factory/gitlectures






