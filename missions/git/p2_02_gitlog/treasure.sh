# Make "git lg" available inside the game.
#
# This file is sourced by every new shell, so it must be quiet, idempotent and
# never ask anything.
#
# "git config --global" writes to World/.gitconfig, which mission 03_git_config
# set up to include -- but never modify -- the player's real configuration.
if ! git config --global --get alias.lg > /dev/null 2>&1
then
    git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
fi
