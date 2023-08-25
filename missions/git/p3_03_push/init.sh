#!/bin/sh


if [ ! -d "$GSH_HOME/Factory" ]
then
   mkdir "$GSH_HOME/Factory"
fi
   
### SET/RESET file has expected at the end of previous mission 
if [ ! -d "$GSH_HOME/Factory/gitlectures" ]
then
    cd $GSH_HOME/Factory
    if [ ! -e "$GSH_HOME/.fork" ]
    then 
       read -p "Please specify the github address of your fork:" fork
       git clone $fork
       echo $yn > $GSH_HOME/.fork
    else
	fork=$(cat $GSH_HOME/.fork)
	git clone $fork
    fi
    cd $GSH_HOME/Factory/gitlectures
    # check that the file is set at initial valuee
    price_line=$(cat product.list | grep stone)
    read -ra ADDR <<< "$price_line"
    price=${ADDR[1]}
    if [[ $price != "100" ]]
    then
	#reset file
	echo "reset file product.list to initial value" 
	echo "# product price" > product.list
	echo "arrow 1" >> product.list
	echo "bow 10" >> product.list
	echo "philosopher's_stone 100" >> product.list
	git add product.list &> /dev/null
	git commit -m "reset level" &>	/dev/null
	git push --force
    fi
fi

cd $GSH_HOME/Factory/gitlectures







