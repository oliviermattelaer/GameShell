#!/bin/sh

# Only a keyless check here: see 00_git/sbin/gsh_github.  Whether github
# accepts the player's key was settled in the "ssh" mission, and asking again
# at every game start would offer the key -- and pop up the macOS keychain
# dialog -- before the player has typed anything.
if ! gsh_github reachable
then
    echo "$(gettext "github.com cannot be reached: skipping the GitHub missions.")"
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
### out of sync and has something to pull.
### This is the one place where setting a mission up has to talk to github
### with the player's own key, so say what is happening: an ssh connection
### nobody asked for is alarming (and on macOS it may ask for the passphrase
### of the key, through the keychain).
echo "$(gettext "setting the mission up: pushing a commit to your fork, so that there is something for you to pull...")"
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
