if [ "$GSH_LAST_ACTION" = "hardreset" ]
then
    rm -rf "$GSH_HOME/Factory"
    mkdir "$GSH_HOME/Factory"
fi
cd "$GSH_HOME/Factory" 2> /dev/null
true
