#!/usr/bin/env sh


if  ! module is-loaded use.own;
then
	echo "To pass this level, please load your new module (via use.own)"
        false
elif  ! module is-loaded  Vim; 
then
    echo "No Vim module loaded. Did you name the module correctly?"
    false
elif which vim | grep ".local"; then
   echo "Well done!"
else
   echo "Invalid vim executable... try again."
   false	
fi



