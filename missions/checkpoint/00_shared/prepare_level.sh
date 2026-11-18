#!/usr/bin/env sh

# Prepare the directory of a cluster level of the checkpoint missions.
#
# usage: prepare_level.sh LEVEL SHARED_DIR
#   (GSH_HOME and GSH_TMP must be set)
#
# The python script and the submission script are taken from the previous
# level (so that the player builds on their own work), with more explanations
# added on top of the submission script.

level=$1
shared=$2
base=$GSH_HOME/Checkpoint
dir=$base/level$level
prev=$base/level$((level - 1))

for cmd in python3 sbatch sacct scancel squeue scontrol
do
  if ! command -v "$cmd" >/dev/null
  then
    echo "The command '$cmd' is required for this mission." >&2
    echo "This part of the game must be played on the login node of a Slurm cluster." >&2
    exit 1
  fi
done

# jobs submitted before the start of the mission are ignored by gsh check
[ -s "$GSH_TMP/ckpt_start_$level" ] || date +%s > "$GSH_TMP/ckpt_start_$level"

# don't erase the player's work when the mission is restarted
[ -d "$dir" ] && exit 0
mkdir -p "$dir"

case $level in
  4|5|6|7)
    script=count_signal.py
    first=4
    ;;
  *)
    script=count_nockpt.py
    first=10
    ;;
esac

# the python script
if [ "$level" -ne "$first" ] && [ -f "$prev/$script" ]
then
  cp "$prev/$script" "$dir/"
elif [ "$script" = count_signal.py ] && [ -f "$base/level3/$script" ]
then
  cp "$base/level3/$script" "$dir/"
else
  cp "$shared/$script" "$dir/"
  if [ "$script" = count_signal.py ]
  then
    echo "Warning: your count_signal.py from level 3 was not found, I copied the template instead." >&2
    echo "Complete it first (see level 3)." >&2
  fi
fi

case $level in
  4|5|6)
    # the computation must last longer than the walltime of the job
    sed 's/^STOP *= *[0-9][0-9]*/STOP = 500/' "$dir/$script" > "$dir/$script~" &&
      mv "$dir/$script~" "$dir/$script"
    ;;
  7|11)
    # keep this level short: a smaller STOP (and a shorter walltime, below)
    sed 's/^STOP *= *[0-9][0-9]*/STOP = 80/' "$dir/$script" > "$dir/$script~" &&
      mv "$dir/$script~" "$dir/$script"
    ;;
esac

# the submission script
if [ "$level" -ne "$first" ] && [ -f "$prev/submit.sh" ]
then
  src=$prev/submit.sh
else
  src=$shared/submit_level$first.sh
fi
{
  head -n 1 "$src"
  if [ "$level" -ne "$first" ] && [ -f "$shared/header_level$level.txt" ]
  then
    cat "$shared/header_level$level.txt"
  fi
  tail -n +2 "$src" | sed "s/--job-name=ckpt_level[0-9]*/--job-name=ckpt_level$level/"
} > "$dir/submit.sh"

case $level in
  7|11)
    # with --signal=...@60, each run lasts 30 to 60 seconds
    sed 's/^#SBATCH --time=.*/#SBATCH --time=00:01:10/' "$dir/submit.sh" > "$dir/submit.sh~" &&
      mv "$dir/submit.sh~" "$dir/submit.sh"
    ;;
esac

if [ -f "$shared/start_coordinator.sh" ] && [ "$level" -ge 10 ]
then
  cp "$shared/start_coordinator.sh" "$dir/"
fi
exit 0
