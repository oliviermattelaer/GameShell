#!/usr/bin/env sh

cd "$GSH_HOME"
#module disable VESUVE 2&> /dev/null
#module purge

#cd "$GSH_HOME"

if [ ! -e .local ]; then
        mkdir .local
fi
cd .local
if [ ! -e modules ]; then
        mkdir modules
fi
cd "$GSH_HOME"



true
