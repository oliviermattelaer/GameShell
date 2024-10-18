#!/bin/sh

cd "${GSH_ROOT}/World/Factory"

if [ -d gitlectures/.git ]
then
   name="gitlectures"
else
   name=""
   for tmp in `ls` 
   do	
   	if [ -d $tmp/.git ]
    	then
	    name=$tmp
    	fi	 
   done
fi

if [[ $name != "" ]]
then
    cd $name
    fork=$(git remote get-url origin)
    #echo "your fork is $fork"
    if [[ $fork == "https://github.com/oliviermattelaer/gitlectures" ]]
    then
        echo "You did clone the original repo, you do not have write access on that one. Please create a fork"
	false
    elif [[ $fork == "https://github.com/oliviermattelaer/gitlectures.git" ]]
    then
        echo "You did clone the original repo, you do not have write access on that one. Please create a fork"
	false
    elif [[ $fork == "git@github.com:oliviermattelaer/gitlectures.git" ]]
    then
        echo "You did clone the original repo, you do not have write access on that one. Please create a fork"
	false
    else
	    echo $fork > $GSH_HOME/.fork
	    echo "Good Work"
	    true
    fi
else
    echo "you did not clone the repo"
    false
fi


