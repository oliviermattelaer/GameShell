#!/usr/bin/env sh

module load Python
python --version | awk '{print $NF}' | gsh check



