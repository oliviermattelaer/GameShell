#!/usr/bin/env sh

target=`module  -t --redirect spider Python | grep Python/2 | head -n1`
release=`module -t --redirect spider $target | grep releases | head -n1`
echo "loading $release $target" 
module load $release $target
ml
gsh check



