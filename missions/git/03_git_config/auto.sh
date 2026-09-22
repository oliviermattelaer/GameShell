#!/bin/sh

cd "$GSH_HOME"
git config --global user.name "John Doe"
git config --global user.email "test@test.com"
gsh check
