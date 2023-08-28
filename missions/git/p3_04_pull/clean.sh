#echo "clean setup with $GSH_LAST_ACTION"
#if [[ "$GSH_LAST_ACTION" == "reset" ]]; then
#rm -rf "$GSH_HOME/Factory"
#mkdir  "$GSH_HOME/Factory"
#cd "$GSH_HOME/Factory"
#el
if [[ "$GSH_LAST_ACTION" == "hardreset" ]]; then
    rm -rf "$GSH_HOME/Factory"
    mkdir  "$GSH_HOME/Factory"
    cd "$GSH_HOME/Factory"
#else
#    echo "no cleaning needed"
fi
cd "$GSH_HOME/Factory/"


