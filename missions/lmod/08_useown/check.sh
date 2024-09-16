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
elif ! which thx_1138.sh; then
   echo "PATH environment variable does not seem to be correctly updated by your module. Please retry"
   false
else
   echo "failed to run script thx_1138.sh (check above for the reason)"
   echo "If the error is ModuleNotFoundError: No module named 'thx1138'"
   echo "Then the issue is that PYTHONPATH is not correctly set"
   echo " Check in particular that the path is absolute"
   false	
fi



