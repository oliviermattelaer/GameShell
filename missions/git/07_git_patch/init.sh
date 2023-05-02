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
fi

if [ ! -e "$GSH_HOME/Factory/produce.py" ]
then
    cp "$MISSION_DIR/../00_git/produce.py" "$GSH_HOME/Factory/"
    git add produce.py &> /dev/null
    git commit -m "version1 of produce.py"
    cp "$MISSION_DIR/../00_git/produce2.py" "$GSH_HOME/Factory/produce.py"
fi


   







