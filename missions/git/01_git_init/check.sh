#!/bin/sh

CURR_DIR=`pwd`

cd "$GSH_HOME"
if [ -d "Factory" ]
then
    cd "Factory"
    if [ -d ".git" ]
    then
	unset goal current  CURR_DIR
	true
    else
	echo "$(gettext "You do not have initialized a repository in the factory")"
	echo "$(gettext "You need to run the git init commnand within that directory")"
	cd "${CURR_DIR}"
	unset goal current CURR_DIR
	false
    fi
else
    echo "$(gettext "You do not have created a directory named Factory")"
    unset goal current CURR_DIR
    false
fi
