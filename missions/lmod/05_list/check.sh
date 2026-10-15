#!/usr/bin/env sh

version=`module  -t --redirect spider Python | grep Python/3 | tr "-" "\n" | grep Python | tr "/" "\n" | grep -v Python | tail -n1`
target=`module  -t --redirect spider Python | grep $version | tail -n1`
release=`module -t --redirect spider $target | grep releases | head -n1`



major_version=`python --version 2>&1 | awk '{print $NF}' | tr "." "\n"| head -n1`

if [ "$major_version" = "2" ]
then
    echo "$(gettext "Looks like this is not Python 3.")"
    unset version target release major_version
    false
else
    curr_version=`python --version 2>&1| awk '{print $NF}'`
    if [ "$curr_version" = "$version" ] 
    then
       echo "Correct version of Python detected. Good job!"
    else
       echo "We were expecting another Python version, but OK, let's check the current one."
    fi	    
    nb=`module  -t --redirect list | wc -l`
    read -p "How many modules are currently loaded? " anscommit
    if [ "$nb" = "$anscommit" ] 
    then
	unset version target release major_version nb
	true
    else
	echo "$(gettext "Looks like this is not correct.")"
        echo "$(gettext "Please retry.")"
        unset version target release major_version nb
	false
    fi
fi
