#!/usr/bin/env sh


echo "Here is a code:"
echo ""
cat test_1.c
echo ""
read -p "Will the two addresses printed will be the same?(y/n)" ans

if [[ "$ans" != "n" ]];
then
    echo "No, In order to guarantee that the value of the variable can not be changed, the content of the variable is copied to another location in memory. And therefore the address of the variable within the function and outside the function is not the same."
    echo "Please compile and run test_1.c to check"
    false

else
    echo "let's continue with a second test..."
    echo "Note that in this case, we pass an address as argument"
    echo ""
    cat test_2.c
    read -p " What is the value of i printed in the main code " ans
    if [[ "$ans" != "0" ]];
    then
       echo "No"
       echo "Please compile test_2.c to see this in action."
       false
    else
        read -p "What is the value of i printed within the function?" ans
        if [[ "$ans" != "0" ]];
        then
            echo "No"
            echo "Please compile test_2.c to see this in action."
            false
        else
            read -p "Is the value printed for the pointer will be the same in both section? (y/n)" ans
           if [[ "$ans" != "y" ]];
           then
               echo "No, the argument is the address itself so it will be the same."
               echo "Please compile test_2.c to see this in action."
               false
           else
             echo "Well done"
             true
           fi
        fi    
    fi
fi
