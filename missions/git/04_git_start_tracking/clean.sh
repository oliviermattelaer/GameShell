
if [[ "$GSH_LAST_ACTION" != "check_false" ]]; then
rm -rf "$GSH_HOME/Factory"
mkdir  "$GSH_HOME/Factory"
echo "stop cleaning"
cd "$GSH_HOME/Factory"
fi
