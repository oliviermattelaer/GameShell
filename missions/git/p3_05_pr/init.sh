#!/bin/sh

if ! gsh_github ssh
then
    echo "$(gettext "github does not accept our ssh key: skipping the GitHub missions.")"
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
