#!/usr/bin/env sh

sinfo -Nhl | grep -co idle | gsh check
