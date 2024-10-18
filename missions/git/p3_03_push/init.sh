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
    price_line=$(cat product.list | grep stone)
    read -ra ADDR <<< "$price_line"
    price=${ADDR[1]}
    if [[ $price != "100" ]]
    then
	#reset file
	echo "reset file product.list to initial value" 
	echo "# product price" > product.list
	echo "arrow 1" >> product.list
	echo "bow 10" >> product.list
	echo "philosopher's_stone 100" >> product.list
	git add product.list &> /dev/null
	git commit -m "reset level" &>	/dev/null
	git push --force
    fi
else
    gitfork=$(git remote get-url origin)
    #echo "GITFORK IS $gitfork"
    # gitfork should have such format https://github.com/oliviermattelaer/gitlectures.git
    prefix="https://"
    if [[ "$gitfork" =~ ^"$prefix" ]]; then
	echo "NOW that we have set an ssh key, we will change for you the protocal used for git clone to ssh (instead of  https)"
	echo "change fork remote to use ssh protocol"
	IFS='/' read -ra ADDR <<< "$gitfork"
	OWNER=${ADDR[3]}
	#echo $OWNER
	#echo "OWNER IS $OWNER"
	REPO=${ADDR[4]}
	git remote set-url origin git@github.com:$OWNER/$REPO
	echo "git@github.com:$OWNER/$REPO" > $GSH_HOME/.fork
	echo "new remote adress is set to git@github.com:$OWNER/$REPO"
	git remote
    fi
fi

cd $GSH_HOME/Factory/gitlectures
