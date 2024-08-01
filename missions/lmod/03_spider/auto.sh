#!/usr/bin/env sh

module -t --raw --redirect spider Python |grep Python | wc -l | gsh check 


