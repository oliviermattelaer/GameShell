#!/usr/bin/env sh


goal_upper=`module -t --raw --redirect spider Python |grep Python | wc -l`
goal_all=`module -t --raw --redirect spider Python python |grep -i python | wc -l`
goal_lower=`module -t --raw --redirect spider python |grep python | wc -l`

uniq_version=`module -t --raw --redirect spider Python |grep Python |  tr "-" "\n" | grep Python | uniq | wc -l` 
#echo "target $goal bad: $uniq_version"
read -p "How many different version of python can you find on the system " anscommit




if [ "$goal_upper" = "$anscommit" ]
then
    unset goal anscommit uniq_version
    true
elif [ "$goal_all" = "$anscommit" ]
 then
     unset goal anscommit uniq_version
     true     
elif [ "$goal_lower" = "$anscommit" ]
 then
     unset goal anscommit uniq_version
     true     
elif [ "$anscommit" = "$uniq_version" ] 
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
