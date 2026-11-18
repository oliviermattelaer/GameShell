# Start a DMTCP coordinator on a free port, and set the variables
# DMTCP_COORD_HOST and DMTCP_COORD_PORT so that dmtcp_launch, dmtcp_command
# and dmtcp_restart_script.sh talk to it.
#
# Use it with
#     . ./start_coordinator.sh
# ("." runs the file in the current shell, so that the variables are set
# there).
#
# Many people use the same login node: using the default port (7779) would
# mix your programs with those of the other users. "-p 0" asks for a free
# port, and "--port-file" writes it in a file.
# "--exit-on-last" stops the coordinator when the last program it manages
# stops.

case $0 in
  *start_coordinator.sh)
    # executed instead of sourced: the variables would be lost
    echo "Run this file with a dot and a space in front:" >&2
    echo "    . ./start_coordinator.sh" >&2
    echo "Otherwise it runs in a separate shell, and the variables" >&2
    echo "DMTCP_COORD_HOST and DMTCP_COORD_PORT are lost when it ends." >&2
    exit 1
    ;;
esac

if ! command -v dmtcp_coordinator >/dev/null
then
  echo "No dmtcp_coordinator found: load the DMTCP module first." >&2
else
  rm -f .dmtcp_port
  dmtcp_coordinator --daemon --exit-on-last -p 0 --port-file .dmtcp_port >/dev/null 2>&1
  for _ in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20
  do
    [ -s .dmtcp_port ] && break
    sleep 0.5
  done
  if [ -s .dmtcp_port ]
  then
    DMTCP_COORD_HOST=$(hostname)
    DMTCP_COORD_PORT=$(cat .dmtcp_port)
    export DMTCP_COORD_HOST DMTCP_COORD_PORT
    echo "DMTCP coordinator started on $DMTCP_COORD_HOST, port $DMTCP_COORD_PORT"
  else
    echo "Could not start the DMTCP coordinator." >&2
  fi
  rm -f .dmtcp_port
fi
