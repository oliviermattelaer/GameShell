#!/bin/sh

cd "${GSH_ROOT}/World/Factory"

# the clone may have been given any name: look for a git repository
if [ -d gitlectures/.git ]
then
    name="gitlectures"
else
    name=""
    for tmp in *
    do
        if [ -d "$tmp/.git" ]
        then
            name=$tmp
        fi
    done
fi

if [ -z "$name" ]
then
    echo "$(gettext "you did not clone the repo")"
    unset name tmp
    false
else
    cd "$name"
    fork=$(git remote get-url origin)
    case $fork in
        # the upstream repository, in any of the forms github proposes:
        # the player has no write access to it and needs their own fork
        https://github.com/oliviermattelaer/gitlectures | \
        https://github.com/oliviermattelaer/gitlectures.git | \
        git@github.com:oliviermattelaer/gitlectures | \
        git@github.com:oliviermattelaer/gitlectures.git)
            echo "$(gettext "You did clone the original repo, you do not have write access on that one. Please create a fork")"
            unset name tmp fork
            false
            ;;
        *)
            printf '%s\n' "$fork" > "$GSH_HOME/.fork"
            echo "$(gettext "Good Work")"
            unset name tmp fork
            true
            ;;
    esac
fi
