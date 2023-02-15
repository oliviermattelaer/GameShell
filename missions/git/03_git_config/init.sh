


if [ ! -d "$GSH_HOME/Factory" ]
then
    mkdir "$GSH_HOME/Factory"
    cd "$GSH_HOME/Factory"
    git init
fi


if [ ! -f "${GSH_ROOT}/World/.gitconfig" ]
then
    cd "${GSH_ROOT}/World"
    ln -s "${REAL_HOME}/.gitconfig"
fi


cd "$GSH_HOME/Factory"
if git config --get user.name
then
    if git config --get user.email
    then
	echo "$(gettext "bypassed $MISSION_NB since name/email already configured")"
	false
    fi
else
    cd "$GSH_HOME/Factory"
fi


