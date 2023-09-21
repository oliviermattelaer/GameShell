echo "clean setup with $GSH_LAST_ACTION"
#if [[ "$GSH_LAST_ACTION" == "reset" ]]; then
#rm -rf "$GSH_HOME/Factory"
#mkdir  "$GSH_HOME/Factory"
#cd "$GSH_HOME/Factory"
#el
if [[ "$GSH_LAST_ACTION" == "check_true" ]]; then
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
        git commit -m "reset level" &>  /dev/null
        git push --force
    fi
else
    echo "no cleaning needed"
fi
cd "$GSH_HOME/Factory/gitlectures"


