#!/bin/sh

# A GitHub fork cannot be created automatically: reuse the address the player
# already gave us if we have one, and otherwise fall back on a fork kept for
# testing.
cd "$GSH_HOME/Factory"
if [ -s "$GSH_HOME/.fork" ]
then
    git clone "$(cat "$GSH_HOME/.fork")" gitlectures
else
    git clone git@github.com:billmoruuv/gitlectures.git
fi
gsh check
