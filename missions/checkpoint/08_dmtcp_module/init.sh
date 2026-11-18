#!/usr/bin/env sh

if ! command -v module >/dev/null
then
  echo "The command 'module' is required for mission $MISSION_NAME." >&2
  echo "This part of the game must be played on a cluster using modules (Lmod)." >&2
  false
fi
