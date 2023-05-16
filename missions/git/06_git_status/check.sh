#!/bin/sh

cd "${GSH_ROOT}/World/Factory"
in_index="should_be_restore_to_last_commit_WARNING_change_already_pushed_in_index.txt"
to_revert="should_be_restore_to_last_commit.txt"


sub_mission=0

#echo "$(gettext "Checking SubMission 1: removal of to_remove.txt")"
#echo "$(gettext "===============================================")"
#if [ ! -e to_remove.txt ];then
#   if git status to_remove.txt | grep "Changes to be committed" >& /dev/null
#   then
#       echo "$(gettext "removal of to_remove.txt is ready to be commited. But is not yet commited. You need to commit that change.")"
#   else
#       if git status to_remove.txt | grep "nothing to commit" >& /dev/null
#       then
#	   echo "$(gettext "Success")"
#	   let "sub_mission+=1"
#       else
#	   echo "$(gettext "you did remove the file but still need to commit your change: git commit -am")"
#       fi
#   fi
#else
#    echo "$(gettext "you did NOT remove the file, you can use 'git rm' or just the standard 'rm' to remove such file.")"
#fi
   echo "$(gettext " ")"
   echo "$(gettext "Checking SubMission 1: RESTORE wrong modification set in the index")"
   echo "$(gettext "=================================================================")"
if git status should_be_restore_to_last_commit_WARNING_change_already_pushed_in_index.txt | grep "Changes to be committed" >& /dev/null
then
   echo "$(gettext "Your file should_be_restore_to_last_commit_WARNING_change_already_pushed_in_index.txt is still not in a clean state. Did you restore the file?")"
elif cat should_be_restore_to_last_commit_WARNING_change_already_pushed_in_index.txt | grep "number of customer is 0" >& /dev/null;
then
	
   echo "$(gettext "Your file should_be_restore_to_last_commit_WARNING_change_already_pushed_in_index.txt has been committed with the wrong version of the file.")"
   echo "$(gettext "You can either reset the level with gsh reset --this will also impact other submission--")"
   echo "$(gettext "Or you can reset only this part of the mission by running 'reset_sub2.sh'")"
   echo "$(gettext "In production, you could")"
   echo "$(gettext "   - restore back the old status of the file via the command 'git restore should_be_restore_to_last_commit_WARNING_change_already_pushed_in_index.txt --source HEAD~1' [HEAD~1 means the last but one commit]")"
   echo "$(gettext "   - remove completely the wrong commit (can be dangerous) via 'git reset --hard HEAD~1 (for the game prefer gsh reset)'")"
else
    echo "$(gettext "Success")"
    let "sub_mission+=1"
fi

echo "$(gettext " ")"
echo "$(gettext "Checking SubMission 2: restore file at last commit")"
echo "$(gettext "==================================================")"

if git status should_be_restore_to_last_commit.txt | grep "Changes not staged" >& /dev/null
then
   echo "$(gettext "The file should_be_restore_to_last_commit.txt contains modification compare to last commit. You should either commit them. Or, more likely, restore previous state)")"
elif git status should_be_restore_to_last_commit.txt | grep "Changes to be committed" >& /dev/null
then
    echo "$(gettext "The file should_be_restore_to_last_commit.txt contains modification compare to last commit. You have put those modification in the index but not yet commited them.")"
    echo "$(gettext "You should either commit them. Or, more likely, restore previous state)")"
    
elif cat should_be_restore_to_last_commit.txt | grep "no data" >& /dev/null
then
     echo "$(gettext "The file should_be_restore_to_last_commit.txt is commited but with the wrong information inside")"
   echo "$(gettext "You can either reset the level with gsh reset")"
   echo "$(gettext "or you can restore the file to the old status thanks to 'git restore FILE --source HEAD~1' [HEAD~1 means the last but one commit]")"
else
    echo "$(gettext "Success")"
    let "sub_mission+=1"     
fi
    
if [[ $sub_mission = 2 ]];
then
    echo "$(gettext " ")"
    echo "Good Job: All passed"
    true
else
    echo "$(gettext " ")"
    echo "$(gettext "You only succeed $sub_mission/2 sub-missions.")"
    false
fi





