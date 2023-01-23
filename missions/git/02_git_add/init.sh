#!/bin/sh

if [ ! -d "$GSH_HOME/Factory" ]
then
    mkdir "$GSH_HOME/Factory"
   cd "$GSH_HOME/Factory"
   git init
fi
   
cd "$GSH_HOME/Factory"
