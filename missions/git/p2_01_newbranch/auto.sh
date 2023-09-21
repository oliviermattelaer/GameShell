#!/bin/sh

git switch -c "NEXTGEN"
sed  's/1.0/2.0.ALPHA/g' welcome.txt > welcome2.txt
mv welcome2.txt welcome.txt
git commit -am "update welcome.txt to start v2"
gsh check


