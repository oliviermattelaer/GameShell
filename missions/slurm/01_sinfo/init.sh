#!/usr/bin/env bash

which sinfo >& /dev/null || { echo "Slurm not found. This game is meant for a Slurm cluster. Aborting."; exit 1; }

cd "$GSH_HOME"
