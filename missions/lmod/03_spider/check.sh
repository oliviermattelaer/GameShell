#!/usr/bin/env sh


goal_upper=`module -t --raw --redirect spider Python |grep Python | wc -l`
goal_all=`module -t --raw --redirect spider Python python |grep -i python | wc -l`
goal_lower=`module -t --raw --redirect spider python |grep python | wc -l`

uniq_version=`module -t --raw --redirect spider Python |grep Python |  tr "-" "\n" | grep Python | uniq | wc -l` 
#echo "target $goal bad: $uniq_version"
read -p "How many different versions of Python can you find on the system? " anscommit




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
    echo "$(gettext "This corresponds to the number of distinct version numbers.")"
    echo "$(gettext "The same version can be compiled with different compilers and may or may not include some extensions (like tqdm).")"
    echo "$(gettext "Please consider those as different for this question.")"
    unset goal anscommit uniq_version
    false
else
	echo "$(gettext "Incorrect (be sure not to add spaces/...)")"
    echo "$(gettext "Please retry.")"
    false
fi
