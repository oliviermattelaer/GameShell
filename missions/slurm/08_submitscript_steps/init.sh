#!/usr/bin/env bash

mkdir -p $GSH_HOME/testjob
[[ -f "$GSH_HOME/testjob/submit.sh" ]] || echo "#!/bin/bash" > "$GSH_HOME/testjob/submit.sh"

