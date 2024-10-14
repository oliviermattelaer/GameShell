#!/bin/sh

in_index="should_be_restored_to_last_commit_WARNING_change_already_pushed_in_index.txt"
#to_revert="should_be_restored_to_last_commit.txt"

cd "${GSH_ROOT}/World/Factory"
git restore --staged $in_index
git restore $in_index
#git restore  $to_revert
#rm to_remove.txt
#git add to_remove.txt
#git commit -m "remove file"
gsh check
