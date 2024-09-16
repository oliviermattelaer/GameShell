#!/usr/bin/env sh


if  ! module is-loaded use.own;
then
	echo "To pass the level, please load your new module (via use.own)"
        false
elif  ! module is-loaded  Vim; 
then
    echo "No MODULE VIM loaded. Did you name the module correctly?"
    false
elif which vim | grep ".local"; then
   echo "well done"
else
   echo "invalid vim executable... try agin"
   false	
fi



