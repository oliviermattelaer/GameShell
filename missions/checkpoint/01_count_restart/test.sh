#!/usr/bin/env sh

echo 4 | gsh assert check false
echo four | gsh assert check false
echo 0 | gsh assert check true
