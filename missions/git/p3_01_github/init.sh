#!/bin/sh


### SET/RESET file has expected at the end of previous mission 
if [ ! -d "$GSH_HOME/Factory" ]
then
   echo "reset full directory"
   mkdir "$GSH_HOME/Factory"
   cd "$GSH_HOME/Factory"
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

   







