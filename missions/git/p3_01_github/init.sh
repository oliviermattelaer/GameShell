#!/bin/sh

# This mission, and the next ones, need a GitHub account and network access.
# Cancel them when github.com cannot be reached: on a laptop with no network,
# or during an automated run, the whole GitHub block is simply skipped.
if ! gsh_github reachable
then
    echo "$(gettext "github.com cannot be reached: skipping the GitHub missions.")"
    return 1
fi

if [ ! -d "$GSH_HOME/Factory" ]
then
    mkdir "$GSH_HOME/Factory"
fi

cd "$GSH_HOME/Factory"
if [ ! -d "$GSH_HOME/Factory/.git" ]
then
    git init --initial-branch=master &> /dev/null
    echo "Welcome to our Factory." > welcome.txt
    echo "This is Factory v1.0 " >> welcome.txt
    echo "# Instructions: remove the 1.0 and replace it by 2.0.ALPHA" >> welcome.txt
    git add welcome.txt &> /dev/null
    git commit -m "first commit" &> /dev/null
fi
