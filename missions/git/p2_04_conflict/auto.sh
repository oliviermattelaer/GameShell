#!/bin/sh

git switch NEXTGEN &> /dev/null
git merge main &> /dev/null
echo "tmp" > welcome.txt
echo "tmp" > factory.sh
git add welcome.txt factory.sh
git commit -m "merge last bug fix"
gsh check


