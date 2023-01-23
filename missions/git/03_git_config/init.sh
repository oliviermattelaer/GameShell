


if [ ! -f "${GSH_ROOT}/World/.gitconfig" ]
then
    cd "${GSH_ROOT}/World"
    echo "REAL HOME ${REAL_HOME}"
    ln -s "${REAL_HOME}/.gitconfig"
fi


if git config --get user.name
then
    if git config --get user.email
    then
	echo "$(gettext "bypassed level3 since name/email already configured")"
    fi
else
    echo "$(gettext "You did not setup your name correctly")"
    cd "$GSH_HOME"
    unset goal current
    false
fi

