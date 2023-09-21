#!/bin/sh

cd "${GSH_ROOT}/World/Factory"
git add welcome.txt
git commit -m "start tracking welcome.txt"
gsh check
