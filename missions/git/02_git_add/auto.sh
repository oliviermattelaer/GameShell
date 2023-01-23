#!/bin/sh

cd "${GSH_ROOT}/World/Factory"
echo "Hello world" > hello.txt
git add hello.txt
gsh check
