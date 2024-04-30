#!/usr/bin/env bash -x
if history  | grep "man sinfo" >& /dev/null
then
    true
else
    echo "Please have a look at the man page for sinfo."
    false
fi
