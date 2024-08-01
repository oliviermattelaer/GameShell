#!/usr/bin/env sh

version=`module  -t --redirect spider Python | grep Python/3 | tr "-" "\n" | grep Python | tr "/" "\n" | grep -v Python | tail -n1`
target=`module  -t --redirect spider Python | grep $version | tail -n1`
release=`module -t --redirect spider $target | grep releases | head -n1`
module load $release $target
module  -t --redirect list | wc -l | gsh check



