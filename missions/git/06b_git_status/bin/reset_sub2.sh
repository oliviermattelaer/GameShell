in_index="in_index_but_change_to_discard.txt"
echo "number of customer is 363" > $in_index
git add $in_index
git commit -m "back original file number of customer" &> /dev/null
echo "number of customer is 0" > $in_index
git add $in_index
git status
