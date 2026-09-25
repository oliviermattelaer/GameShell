#!/bin/sh

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

cp "$MISSION_DIR/setup_ssh.sh" "$GSH_HOME/Factory/gitlectures/setup_ssh"
chmod +x "$GSH_HOME/Factory/gitlectures/setup_ssh"
cd "$GSH_HOME/Factory/gitlectures"
true
