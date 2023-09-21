#!/bin/sh

cd "${GSH_ROOT}/World/Factory"

if [ -d gitlectures/.git ]
then
    cd gitlectures
    fork=$(git remote get-url origin)
    if [[ $fork == "https://github.com/oliviermattelaer/gitlectures" ]]
    then
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


