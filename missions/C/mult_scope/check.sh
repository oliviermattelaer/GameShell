#!/usr/bin/env sh


echo "Not so fast... This would be too easy..."
echo "let check that you have understood the concept so far. here is a code:"
echo ""
cat input_1.c
echo ""
read -p " What is the value of \"j\" printed at the end of the code?" ans

if [[ "$ans" != "0" ]];
then
    echo "No, Variable have scope and each scope (a {} section) can have his own variable name (here we have two \"j\" one for the for loop and one for the rest of the code. One does not impact the other."
    echo "Please compile and run test_1.c to see it in action"
    false
else
    echo "let's continue with a second test..."
    echo ""
    cat test_2.c
    read -p " What is the value of length at the end of the code? " ans
    if [[ "$ans" != "10" ]];
    then
       echo "No, each block have their own variable, they can have the same name but they are different. A function can not change the variable within a function."
       echo "Please compile test_2.c to see this in action."
    else
        echo "Well done"
        true
    fi
fi
