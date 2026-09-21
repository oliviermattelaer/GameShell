#!/usr/bin/env sh

cd "$GSH_HOME"
cp -Rp "$(parcomp_src)" .
gsh check
