#!/usr/bin/env sh

cd $GSH_HOME
mkdir testjob
echo '#!/bin/bash' > testjob/submit.sh
gsh check
