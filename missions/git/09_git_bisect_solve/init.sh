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
   rm produce.py
fi

if [ ! -e "$GSH_HOME/Factory/produce.py" ]
then
    cp "$MISSION_DIR/../00_git/bisect_produce.py" "$GSH_HOME/Factory/produce.py"
    cp "$MISSION_DIR/../00_git/change_bisect.py" "$GSH_HOME/Factory/change_bisect.py"
    chmod +x produce.py
    git add produce.py &> /dev/null
    git commit -m "version1 of produce.py"
    git tag before_shutdown
    python3 change_bisect.py &> /dev/null
    rm change_bisect.py 
fi


   







