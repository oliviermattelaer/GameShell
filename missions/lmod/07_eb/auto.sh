#!/usr/bin/env sh

module purge 
module load releases/2022b
eb /usr/local/easybuild/easyconfigs/v/Vim/Vim-9.0.1434-GCCcore-12.2.0.eb
module load use.own Vim

gsh check

