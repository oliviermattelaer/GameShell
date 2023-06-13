#!/bin/sh

git switch NEXTGEN &> /dev/null
git merge main &> /dev/null
gsh check


