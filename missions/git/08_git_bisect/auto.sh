#!/bin/sh

git bisect start
git bisect bad
git bisect good HEAD~64
git bisect run ./produce.py 
bad_commit=`git bisect run ./produce.py | grep "is the first bad commit" | awk '{print $1}'`
git bisect reset
git revert $bad_commit --no-edit
