#!/usr/bin/env bash -x

NIDLE=$(sinfo -Nhl | grep -co idle)
read -p "How many worker gnomes are currently idle ? " NB

if [[ $NIDLE == $NB ]]
then
    true
else
    echo "Hum that is not what I expected. Maybe re-count again?"
    false
fi
