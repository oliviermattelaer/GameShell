#!/bin/sh

git stash
git switch main
git stash apply
git commit -am "fix issue"
gsh check



