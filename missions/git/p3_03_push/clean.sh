if [ "$GSH_LAST_ACTION" = "hardreset" ] || [ "$GSH_LAST_ACTION" = "reset" ]
then
    rm -rf "$GSH_HOME/Factory"
    mkdir "$GSH_HOME/Factory"
fi
cd "$GSH_HOME/Factory" 2> /dev/null
true
