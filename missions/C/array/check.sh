#!/usr/bin/env sh


echo "Not so fast... This would be too easy..."
echo "let's check that you have understood the concept so far. Here is a code:"
echo ""
cat test_1.c
echo ""
read -p " What is the value printed at the end of the code?" ans

if [[ "$ans" != "5" ]];
then
    echo "No, Remember that the first index is 0"
    echo "To check you can compile/run test_1.c"
    false
else
        echo "Well done"
        true
fi
