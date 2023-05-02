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

   # maybe not the correct test
   #if [ ! -e "$GSH_HOME/Factory/to_remove.txt" ]
   #then
   #   echo "OOOPS" > to_remove.txt
   #   git add to_remove.txt
   #   git commit -m "adding file that need to be removed"
   #   echo "This file needs to be remove from the next commit" > to_remove.txt
   #fi
   #git restore should_be_reverted_to_last_commit.txt
   #git restore --staged in_index_but_change_to_discard.txt
   in_index="in_index_but_change_to_discard.txt"
   to_revert="should_be_reverted_to_last_commit.txt"
   if [ ! -e "$GSH_HOME/Factory/$to_revert" ]
   then
      echo "last correct information" > $to_revert
      git add $to_revert
      git commit -m "original file financial information"
      echo "no data (all erased) what did I do?" > $to_revert
   fi
   # this need to be last since we need to not have any commit
   # after the git add
   if [ ! -e "$GSH_HOME/Factory/$in_index" ]
   then
      echo "number of customer is 363" > $in_index
      git add $in_index
      git commit -m "original file number of customer"
      echo "number of customer is 0" > $in_index
      git add $in_index
   fi

fi






