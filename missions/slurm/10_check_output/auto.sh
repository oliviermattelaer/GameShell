#!/usr/bin/env sh

cd $GSH_HOME
mkdir -p testjob
echo '#!/bin/bash' 
cat <<EOT  > testjob/submit.sh
#!/bin/bash

#SBATCH --time=10:00
#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=1000MB

srun hostname
srun sleep 90
EOT

sbatch --parsable testjob/submit.sh | gsh check
