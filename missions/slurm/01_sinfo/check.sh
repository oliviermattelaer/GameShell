#!/usr/bin/env bash -x

NLINES=$(sinfo -Nhl | wc -l)
read -p "How many worker gnomes are there ? " NB

if [[ $NLINES == $NB ]]
then
    true
elif [[ $NLINES == $((NB+1)) ]] ; then
    echo "That was close. Maybe you counted the header? Try again."
    false
else
    echo "You might want to recount that."
    false
fi
