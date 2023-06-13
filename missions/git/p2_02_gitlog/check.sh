#!/bin/sh

cd "${GSH_ROOT}/World/Factory"

read -p "What is the number of bug fix in the main branch? Since NEXTGEN diverged from it?" ansmain
read -p "What is the number of additional commit in the NEXTGEN branch?" ansnext

echo "you enter $ansmain and $ansnext"

if [ "$ansmain" == "3" ] ;
then
    echo "$(gettext "Wrong: \"3\" is the total number of commit in the main branch. Not the number since NEXTGEN has branch from it")."
    echo "$(gettext "By default, git log only shows the commit from the given branch. Use \"git log BRANCH1 BRANCH2 --graph\" to see both")"
    unset goal current ansmain ansnext
    false
elif [ "$ansmain" != "1" ] ;
then
    echo "$(gettext "This is not correct number for the main branch. Please check and try again.")"
    unset goal current ansmain ansnext
    false
elif [ "$ansnext" == "5" ] ;
then
    echo "Wrong: \"5\" is the total number \
of commit in the NEXTGEN branch. Not the number since NEXTGEN has branch from main"
    unset goal current ansmain ansnext
    false
elif [ "$ansnext" != "3" ] ;
then
    echo "$(gettext "This is not correct number for the NEXTGEN branch. Please check and try again.")"
    unset goal current ansmain ansnext
    false
else
    echo "Well Done"
    unset goal current ansmain ansnext
    true
fi


