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
fi
# fork is expected to be https://github.com/OWNER/gitlectures.git

cd $GSH_HOME/Factory/gitlectures
#git remote
#git remote get-url origin
gitfork=`git remote get-url origin`

#echo "GITFORK IS $gitfork"
prefix="https://"
if [[ "$gitfork" =~ ^"$prefix" ]]; then
    echo "Congratulations for adding your ssh key"
    echo "Your repo is still setup to use https protocol"
    echo "to simplify our setup, the game has change your fork to use ssh protocol for the remote repository"
    IFS='/' read -ra ADDR <<< "$gitfork"
    OWNER=${ADDR[3]}
    echo $OWNER
    #echo "OWNER IS $OWNER"
    git remote set-url origin git@github.com:$OWNER/gitlectures.git
    echo "git@github.com:$OWNER/gitlectures.git" > $GSH_HOME/.fork
    echo "new adress is now git@github.com:$OWNER/gitlectures.git"
    echo "in future you can copy/paste directly the \"ssh\" adress of your fork"
    #git remote
fi


