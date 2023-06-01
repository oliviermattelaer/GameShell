set_git_lg() {
    git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --"
    }
git log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit main NEXTGEN

echo "With more options within git log, you can achieve \
the above result."
echo "The full command was \"git log --color --graph --pretty=format:'%Cred%h%Creset -%C\
(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit main NEXTGEN\""
echo ""
echo "In git, you create alias to avoid to always typing such optional parameter."

read -p "Do you want me to define \"git lg\" as an alias for the above option? The above display will then be git lg main NEXTGEN. (y/n)" ansmain

if [ "$ansmain" == "y" ]
then
git config --global alias.lg "log --color --graph --pre\
tty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
else
    false
fi
