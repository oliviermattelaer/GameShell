#!/bin/sh

if ! gsh_github ssh
then
    echo "$(gettext "github does not accept our ssh key: skipping the GitHub missions.")"
    return 1
fi

### SET/RESET file as expected at the end of previous mission
fork=$(gsh_fork_setup)
if [ -z "$fork" ]
then
    echo "$(gettext "your fork of gitlectures is not available: skipping the GitHub missions.")"
    unset fork
    return 1
fi

### push a commit from a throw-away clone, so that the player's own clone is
### out of sync and has something to pull
cd "$GSH_HOME"
rm -rf "$GSH_HOME/.gitlectures-sync"
if git clone "$fork" "$GSH_HOME/.gitlectures-sync" &> /dev/null
then
    cd "$GSH_HOME/.gitlectures-sync"
    echo "I have succeed level 14 on $(date)" >> status
    git add status &> /dev/null
    git commit -m "automatic push of one more commit to create out of sync" &> /dev/null
    git push &> /dev/null
    cd "$GSH_HOME"
fi
rm -rf "$GSH_HOME/.gitlectures-sync"
unset fork

### go back to the original directory
cd "$GSH_HOME/Factory/gitlectures"
true
