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
   git init &> /dev/null
   echo "Welcome to our Factory." > welcome.txt
   git add welcome.txt &> /dev/null
   git commit -m "first commit"
   echo "Welcome to our Factory." > welcome.txt
   echo "MISSION: Please remove any line starting with a hash (#)." >> welcome.txt
   echo "# TODO: check that our factory has electricity: OK Done" >> welcome.txt
   echo "# TODO: check our supply chain: OK done" >> welcome.txt
   git commit -am "Update TODO LIST"
fi






