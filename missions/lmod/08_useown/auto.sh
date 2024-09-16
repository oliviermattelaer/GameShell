#!/usr/bin/env sh

module purge 
module load use.own

cd ~/.local/modules
mkdir THX
cd THX
echo "conflict(\"THX\")" > 1138.lua
echo "load(\"releases/2022b\")" >> 1138.lua
echo "load(\"Python/3.10\")" >> 1138.lua
echo "append_path(\"PATH\", \"~/Movies/gl_1971/\")" >> 1138.lua
echo "append_path(\"PYTHONPATH\", \"~/Movies/lib/site-package/python3.10\")" >> 1138.lua 

module load use.own THX

gsh check

