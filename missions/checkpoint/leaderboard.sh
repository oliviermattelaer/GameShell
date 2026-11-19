#!/bin/bash
#
# Leaderboard for a GameShell game, for the instructor: the current mission
# of each player, and their Slurm jobs, with their state, time used, time
# limit and pending reason.
#
# For the checkpoint game, only the jobs of the game are shown (ckpt_levelN);
# for any other game (e.g. slurm), all the jobs of the players.
#
# usage: leaderboard.sh [GAME [REFRESH]]
#   GAME     name of the game (default: checkpoint): the players are the
#            users running GAME.gsh, their log is ~USER/GAME/.config/missions.log
#            (examples: checkpoint, slurm)
#   REFRESH  seconds between two refreshes (default: 20; 0: display once)
#
# The players are found with ps: run it on the login node they use. For the
# checkpoint game, users with a job of the game but no running game are
# listed too.

GAME=${1:-checkpoint}
REFRESH=${2:-20}
NAMES=ckpt_level4,ckpt_level5,ckpt_level6,ckpt_level7,ckpt_level10,ckpt_level11

# last line of the most recent mission log of user $1: "MISSION AGE"
mission_of() {
  local home log best=""
  home=$(eval echo "~$1")
  for log in "$home/$GAME/.config/missions.log" "$home/$GAME".[0-9]*/.config/missions.log
  do
    [ -r "$log" ] || continue
    if [ -z "$best" ] || [ "$log" -nt "$best" ]
    then
      best=$log
    fi
  done
  if [ -z "$best" ]
  then
    echo "- -"
    return
  fi
  tail -n 1 "$best" | awk -v now="$(date +%s)" '{
    age = now - $3
    if (age < 60) a = age "s"; else if (age < 3600) a = int(age / 60) "m"; else a = int(age / 3600) "h"
    print $1, a
  }'
}

show() {
  local players jobs user
  players=$(ps -eo user=,args= | grep "[g]ameshell/.*$GAME\.gsh" | awk '{print $1}' | sort -u)
  # one squeue for everybody: USER|JOBID|NAME|STATE|TIME|LIMIT|REASON
  if [ "$GAME" = checkpoint ]
  then
    jobs=$(squeue -h -n "$NAMES" -o '%u|%i|%j|%T|%M|%l|%r')
  elif [ -n "$players" ]
  then
    jobs=$(squeue -h -u "$(echo $players | tr ' ' ,)" -o '%u|%i|%j|%T|%M|%l|%r')
  else
    jobs=
  fi

  echo "LEADERBOARD $GAME    $(date +%H:%M:%S)"
  echo "-----------"
  {
    echo "PLAYER MISSION LAST_ACTION JOBID JOB STATE TIME LIMIT REASON"
    for user in $( { echo "$players"; echo "$jobs" | cut -d '|' -f 1; } | grep . | sort -u)
    do
      mission=$(mission_of "$user")
      echo "$jobs" | awk -F '|' -v u="$user" -v m="$mission" '
        $1 == u {
          sub(/^ckpt_/, "", $3)
          gsub(/ /, "_", $3)
          reason = ($7 == "None") ? "-" : $7
          gsub(/ /, "_", reason)
          print u, m, $2, $3, $4, $5, $6, reason
          found = 1
        }
        END { if (!found) print u, m, "-", "-", "-", "-", "-", "-" }'
    done | sort -k 2,2nr -k 1,1
  } | column -t
}

while true
do
  if [ "$REFRESH" -gt 0 ]
  then
    clear
  fi
  show
  [ "$REFRESH" -gt 0 ] || break
  sleep "$REFRESH"
done
