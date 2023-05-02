#!/bin/sh

cp $MISSION_DIR/../00_git/produce_target.py produce.py
git commit -am "automatic change to target"
gsh check
