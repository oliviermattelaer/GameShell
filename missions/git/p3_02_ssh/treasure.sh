# Sourced by every new shell: it must be quiet, idempotent and never ask
# anything.
#
# Now that github accepts the player's ssh key, switch their fork from the
# https remote to the ssh one, so that "git push" stops asking for a password.
if [ -d "$GSH_HOME/Factory/gitlectures/.git" ]
then
    gsh_gitfork=$(git -C "$GSH_HOME/Factory/gitlectures" remote get-url origin 2> /dev/null)
    case $gsh_gitfork in
        https://github.com/*)
            gsh_gitpath=${gsh_gitfork#https://github.com/}
            gsh_gitpath=${gsh_gitpath%.git}
            git -C "$GSH_HOME/Factory/gitlectures" \
                remote set-url origin "git@github.com:$gsh_gitpath.git"
            printf '%s\n' "git@github.com:$gsh_gitpath.git" > "$GSH_HOME/.fork"
            echo "$(gettext "Your fork now uses the ssh protocol, so git will no longer ask for a password.")"
            ;;
    esac
    unset gsh_gitfork gsh_gitpath
fi
