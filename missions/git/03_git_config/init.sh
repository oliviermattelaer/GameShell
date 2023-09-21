


if [ ! -d "$GSH_HOME/Factory" ]
then
    mkdir "$GSH_HOME/Factory"
    cd "$GSH_HOME/Factory"
    git init  &> /dev/null
fi


if [ ! -f "${GSH_ROOT}/World/.gitconfig" ]
then
    cd "${GSH_ROOT}/World"
    ln -s "${REAL_HOME}/.gitconfig"
fi


cd "$GSH_HOME/Factory"
if git config --get user.name &> /dev/null
then
    if git config --get user.email  &> /dev/null
    then
	echo "$(gettext "bypassed $MISSION_NB since name/email already configured")"
	gsh check
	false
    fi
else
    cd "$GSH_HOME/Factory"
fi


