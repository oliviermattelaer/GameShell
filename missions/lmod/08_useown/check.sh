#!/usr/bin/env sh


if  ! module is-loaded use.own;
then
	echo "To pass the level, please load your new module (via use.own)"
        false
elif  ! module is-loaded  THX/1138; 
then
    echo "No MODULE THX/1138 loaded. Did you name the module correctly?"
    false
elif thx_1138.sh > /dev/null; then
   echo "well done"
else
   echo "failed to run script thx_1138.sh (check above for the reason)"
   false	
fi



