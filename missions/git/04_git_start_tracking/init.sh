#!/bin/sh


if [ ! -d "$GSH_HOME/Factory" ]
then
   mkdir "$GSH_HOME/Factory"
   cd "$GSH_HOME/Factory"
fi
   
cd "$GSH_HOME/Factory"
if [ ! -d "$GSH_HOME/Factory/.git" ]
then
   git init &> /dev/null
fi
echo "Welcome to our Factory." > welcome.txt
