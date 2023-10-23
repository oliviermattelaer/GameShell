#!/bin/sh

git stash
git switch master
git stash apply
git commit -am "fix issue"
gsh check



