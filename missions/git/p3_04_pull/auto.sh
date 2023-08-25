#!/bin/sh
git pull
#reset file
echo "reset file product.list to initial value"
echo "# product price" > product.list
echo "arrow 1" >> product.list
echo "bow 10" >> product.list
echo "philosopher's_stone 50" >> product.list
git add product.list &> /dev/null
git commit -m "change philosopher stone price in product.list" &>   /dev/null
git push 
gsh check


