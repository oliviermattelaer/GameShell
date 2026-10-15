#!/usr/bin/env sh

cd "$GSH_HOME"

# TEMPORARY workaround: with Lmod's cached loads (LMOD_CACHED_LOADS=True,
# e.g. on lemaitre4), "module load use.own" fails with
# "Did not find mpath in mA". Remove once the cluster's Lmod is fixed.
export LMOD_CACHED_LOADS=no

module purge &>/dev/null



true
