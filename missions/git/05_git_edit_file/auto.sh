#!/bin/sh

cd "${GSH_ROOT}/World/Factory"
cat welcome.txt | grep -v "# TODO" > welcome2.txt
mv welcome2.txt welcome.txt
git add welcome.txt
git commit -m "Remove todo list"
gsh check
