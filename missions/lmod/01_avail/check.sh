#!/usr/bin/env sh

goal=`module load Python && python --version | awk '{print $NF}'`
defpython=`python3 --version | awk '{print $NF}'`
echo "target $goal bad: $defpython "
read -p "What is the version number of the default python program that you can use? " anscommit

if [ "$goal" = "$anscommit" ]
then
    unset goal anscommit defpython
    true
elif [ "$anscommit" = "$defpython" ] 
then
    echo "$(gettext "This is the default version for python3 on the OS. This is bad to use on cluster since it can differ on each machine.")"
    echo "$(gettext "This does not provide the python executable --only python3--")"
    echo "$(gettext "Please Retry")"
    unset goal anscommit defpython
    false
elif [ "$anscommit" = "2.7.12" ]
then
   echo "$(gettext "Incorrect, we expect an answer LIKE 2.7.12 (but this is NOT the correct answer)")"
    echo "$(gettext "Please Retry")"
    false
else
    echo "$(gettext "Incorrect, we expect an answer like 2.7.12")"
    echo "$(gettext "Please Retry")"
    false
fi
