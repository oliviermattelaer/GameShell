#!/usr/bin/env sh


if  ! module is-loaded use.own;
then
	echo "To pass this level, please load your new module (via use.own)"
        false
elif  ! module is-loaded  THX/1138; 
then
    echo "No THX/1138 module loaded. Did you name the module correctly?"
    false
elif thx_1138.sh > /dev/null; then
   echo "Well done!"
elif ! which thx_1138.sh; then
   echo "The PATH environment variable does not seem to be correctly updated by your module. Please retry."
   false
else
   echo "Failed to run the script thx_1138.sh (see above for the reason)."
   echo "If the error is ModuleNotFoundError: No module named 'thx1138'"
   echo "then the issue is that PYTHONPATH is not correctly set."
   echo "Check in particular that the path is absolute."
   false	
fi



