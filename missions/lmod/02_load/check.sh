#!/usr/bin/env sh

goal=`module load Python && which python`
defpython=`which python3 2&> /dev/null | awk '{print $NF}'`
echo "target $goal bad: $defpython "
read -p "What is the output of the command 'which python'? " anscommit

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
else
	echo "$(gettext "Incorrect (be sure to not add space/...)")"
    echo "$(gettext "Please Retry")"
    false
fi
