if [ -e ${REAL_HOME}/.vimrc ] 
then
    cp "${REAL_HOME}/.vimrc" "${GSH_HOME}/.vimrc"
else 
    cp "$MISSION_DIR/.vimrc" "${GSH_HOME}/.vimrc"
fi


