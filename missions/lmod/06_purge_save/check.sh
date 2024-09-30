#!/usr/bin/env sh



if  ! module is-loaded  R/4.2.2-foss-2022b; 
then
    echo "R not loaded"
    false
elif ! module is-loaded netCDF/4.9.0-gompi-2022b;
then
	echo "netCDF not loaded"
	false
elif ! module is-loaded Java/11.0.20;
then	
    echo "Java/11.0.20 not loaded (note this is not the default Java for this release)"
	false
elif ! module -t --redirect savelist | grep VESUVE;
then
	echo "collection VESUVE not found"
	false
else
	echo "well done"
fi


