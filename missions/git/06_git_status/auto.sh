#!/bin/sh

cd "${GSH_ROOT}/World/Factory"
git restore --staged in_index_but_change_to_discard.txt
git restore in_index_but_change_to_discard.txt
git restore  should_be_reverted_to_last_commit.txt
#rm to_remove.txt
#git add to_remove.txt
git commit -m "remove file"
gsh check
