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
if ! gsh_fork_setup > /dev/null
then
    echo "$(gettext "your fork of gitlectures is not available: skipping the GitHub missions.")"
    return 1
fi

cd "$GSH_HOME/Factory/gitlectures"
true
