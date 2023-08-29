#!/bin/sh

git switch NEXTGEN &> /dev/null
git merge master &> /dev/null
gsh check


