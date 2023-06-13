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
   # First commit (three file welcome, readme, factory.sh)
   git init &> /dev/null
   echo "Welcome to our Factory." > welcome.txt
   echo "This is Factory v1.0 " >> welcome.txt
   git add welcome.txt &> /dev/null
   echo "This is Readme for v1.0" > readme.txt
   git add readme.txt
   echo "echo 'running factory'" > factory.sh
   for i in {1..100}
   do
       echo "echo '$i'" >> factory.sh 
   done
   git add factory.sh
   git commit -m "first commit" &> /dev/null
   # Second commit
   echo "To start the factory run ./factory.sh" >> readme.txt
   git commit -am "update Readme" &> /dev/null
   # create branch NEXTGEN  commit 2
   git switch -c "NEXTGEN"  &> /dev/null
   sed  's/1.0/2.0.ALPHA/g' welcome.txt > welcome2.txt
   mv welcome2.txt welcome.txt
   git commit -am "update welcome.txt to start v2"  &> /dev/null
   sed  's/factory/updated factory/g' factory.sh > factory2.sh
   mv factory2.sh factory.sh
   
   git commit -am "better factory.sh script"  &> /dev/null
   sed  's/factory/better factory/g' factory.sh > factory2.sh
   mv factory2.sh factory.sh
   git commit -am "even better factory.sh script"    &> /dev/null
   # back to main
   git switch main  &> /dev/null
   echo "echo '101'" >> factory.sh
   git commit -am "fixing main script end condition was wrong"    &> /dev/null
fi

   







