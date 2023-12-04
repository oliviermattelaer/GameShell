#!/bin/sh
git pull
#reset file
echo "reset file product.list to initial value"
echo "# product price" > SOLDOUT_waiting_for_stock.list
echo "Love potion 7/12/1215" >> SOLDOUT_waiting_for_stock.list
echo "Excalibur 30/05/542" >> SOLDOUT_waiting_for_stock.list
echo "philosopher's stone 1/1/1" >> SOLDOUT_waiting_for_stock.list
git add SOLDOUT_waiting_for_stock.list &> /dev/null
git commit -m "change philosopher stone put in sold out" &>   /dev/null
git push 
gsh check


