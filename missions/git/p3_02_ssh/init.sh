#!/bin/sh


if [ ! -d "$GSH_HOME/Factory" ]
then
   mkdir "$GSH_HOME/Factory"
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
fi

#echo "testing if ssh is correctly configured for github"
# testing if ssh setup is already done
ssh -oStrictHostKeyChecking=no -T git@github.com 1> $GSH_HOME/log 2>&1
if cat $GSH_HOME/log | grep "oliviermattelaer"
then
     echo "ssh configured correctly but for/with admin user access ..."
     echo "do not set level in autowin mode"
     rm $GSH_HOME/log
     touch  $GSH_HOME/log     
fi

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
    cd $GSH_HOME/Factory/gitlectures
    true
fi







