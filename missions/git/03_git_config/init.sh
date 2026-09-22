#!/bin/sh

if [ ! -d "$GSH_HOME/Factory" ]
then
    mkdir "$GSH_HOME/Factory"
    cd "$GSH_HOME/Factory"
    git init &> /dev/null
fi


# The game sets HOME to $GSH_HOME, so git does not see the player's real
# configuration.  Give the world its own ~/.gitconfig that *includes* the real
# one: a player who already configured git keeps their identity (and this
# mission becomes an auto-win), while anything the game or the player writes
# with "git config --global" stays inside the world.
#
# Earlier versions of this mission made World/.gitconfig a symbolic link to
# the real file, which meant the game could modify it.  Replace it.
if [ -L "${GSH_ROOT}/World/.gitconfig" ]
then
    rm --system -f "${GSH_ROOT}/World/.gitconfig"
fi
if [ ! -e "${GSH_ROOT}/World/.gitconfig" ] && [ -f "${REAL_HOME}/.gitconfig" ]
then
    {
        echo "# written by GameShell: your own configuration is included below,"
        echo "# and anything you change here stays inside the game."
        echo "[include]"
        echo "	path = ${REAL_HOME}/.gitconfig"
    } > "${GSH_ROOT}/World/.gitconfig"
fi


cd "$GSH_HOME"
if git config --get user.name > /dev/null 2>&1 && git config --get user.email > /dev/null 2>&1
then
    echo "$(eval_gettext "bypassed \$MISSION_NB since name/email already configured")"
    gsh check
    return 1
fi
true
