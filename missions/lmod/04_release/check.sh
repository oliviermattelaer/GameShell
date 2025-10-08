#!/usr/bin/env sh

read -p "In which release are you able to load Python version 2?" ansversion

echo "$ansversion"
if [ "$ansversion" = "2021b" ]
then
	true
elif [ "$ansversion" = "2022b" ]
then
	true
elif [ "$ansversion" = "releases/2021b" ]
then
	true
elif [ "$ansversion" = "releases/2022b" ]
then
	true
else
   echo "$(gettext "Incorrect, you should do 'module spider Python/2.7.18-GCCcore-12.2.0-bare' and read the output to find out.")"
   false
fi

