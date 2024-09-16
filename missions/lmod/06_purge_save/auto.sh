#!/usr/bin/env sh

module purge 
module load releases/2022b
module load R/4.2.2-foss-2022b
module load netCDF/4.9.0-gompi-2022b
module load Java/11.0.20
module save VESUVE

gsh check

