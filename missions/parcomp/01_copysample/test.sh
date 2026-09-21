#!/usr/bin/env sh

rm -rf "$GSH_HOME/parcomp"
gsh assert_check false

mkdir "$GSH_HOME/parcomp"
gsh assert_check false

cp -Rp "$(parcomp_src)/." "$GSH_HOME/parcomp/"
gsh assert_check true
