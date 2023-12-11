#!/bin/sh

cd "${GSH_ROOT}/World/Factory"

if [ -d gitlectures/.git ]
then
    cd gitlectures
    fork=$(git remote get-url origin)
    if [[ $fork == "https://github.com/oliviermattelaer/gitlectures" ]]
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


