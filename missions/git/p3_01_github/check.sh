#!/bin/sh

cd "${GSH_ROOT}/World/Factory"

if [ -d gitlectures/.git ]
then
    echo "Good Work"
    true
else
    echo "you did not clone the repo"
    false
fi


