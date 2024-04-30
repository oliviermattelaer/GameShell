#!/usr/bin/env bash -x

PART=$(sinfo -ho%P | grep \*)
PART=${PART%%\*} 

read -p "What is the name of the default partition ? " PARTA

if [[ $PARTA ==  $PART ]]
then
    true
else
    if [[ $PARTA == ${PART,,} ]] ; then
        echo "Warning! The partition names are case sensitive. Please give the name with the correct case."
        false
    else
        echo "Are you sure? Look carefully for the asterisk (*)."
    false
    fi
fi
