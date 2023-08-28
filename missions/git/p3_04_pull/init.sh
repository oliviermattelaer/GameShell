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
    cd $GSH_HOME/Factory/gitlectures
    # check that the file is set at initial valuee
fi
fork=$(cat $GSH_HOME/.fork)


cd $GSH_HOME/Factory/gitlectures

git fetch --dry-run &> /tmp/test
status=`cat /tmp/test | grep origin`
i=0
while [[ $status == '' ]]
do
    if (( $i <5 ))
    then
	echo "waiting for github remote repository to setup itself for next level ${i}/5"
    else
	echo "waiting for github remote repository to setup itself for next level $i/15"
    fi
    #git fetch --dry-run
    sleep 1
    i=$(($i+1))
    #i=`$i+1`
    if (( $i == 5 ))
    then
	echo "Force a new commit to force the setting of github"
	echo "# add line to force github action" >> product.list
	git add product.list &> /dev/null
	git commit -am "second try with github action" &> /dev/null
	#git push --set-upstream $fork master
	git push  &> /dev/null
    elif (( $i > 15 ))
    then
	break
    fi
    git fetch --dry-run &> /tmp/test
    cat /tmp/test
    status=`cat /tmp/test | grep origin`
done



#git fetch --dry-run &> /tmp/test
#cd $GSH_HOME/Factory/gitlectures







