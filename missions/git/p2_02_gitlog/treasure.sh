set_git_lg() {
    git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --"
}

git log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit master NEXTGEN

#echo "With more options within git log, you can achieve \
#the above result."
#echo "The full command was \"git log --color --graph --pretty=format:'%Cred%h%Creset -%C\
#(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit main NEXTGEN\""
#echo ""
#echo "In git, you create alias to avoid to always typing such optional parameter."

read -p "Do you want me to define \"git lg\" outside of the game? (y/n)" ansmain

if [ "$ansmain" == "y" ]
then
    git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
else
    cp -L ${GSH_ROOT}/World/.gitconfig tmp && mv ${GSH_ROOT}/World/.gitconfig tmp2 && mv tmp ${GSH_ROOT}/World/.gitconfig
    git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
fi
