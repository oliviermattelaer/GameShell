#!/usr/bin/env sh

goal=`module -t --raw --redirect spider Python |grep Python | wc -l`
uniq_version=`module -t --raw --redirect spider Python |grep Python |  tr "-" "\n" | grep Python | uniq | wc -l` 
echo "target $goal bad: $uniq_version"
read -p "How many different version of python can you find on the system " anscommit

if [ "$goal" = "$anscommit" ]
then
    unset goal anscommit uniq_version
    true
elif [ "$anscommit" = "$defpython" ] 
then
    echo "$(gettext "This correspond to the number of revision.")"
    echo "$(gettext "The same version revision can have been compiled with different compiler and might (or not) include some extension (like tqdm)")"
    echo "$(gettext "Please consider those as different for this question.")"
    unset goal anscommit uniq_version
    false
else
	echo "$(gettext "Incorrect (be sure to not add space/...)")"
    echo "$(gettext "Please Retry")"
    false
fi
