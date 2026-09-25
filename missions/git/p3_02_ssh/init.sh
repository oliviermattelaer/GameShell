#!/bin/sh

if ! gsh_github reachable
then
    echo "$(gettext "github.com cannot be reached: skipping the GitHub missions.")"
    return 1
fi

# ssh resolves ~/.ssh from the password database, not from $HOME, so it would
# otherwise ignore the configuration the "ssh" mission wrote in the game and
# use the player's real keys instead.  This also has to reach the player's own
# shell, so that their "git push" goes to the right account.
if [ -f "$GSH_HOME/.ssh/config" ]
then
    export GIT_SSH_COMMAND="ssh -F $GSH_HOME/.ssh/config"
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
