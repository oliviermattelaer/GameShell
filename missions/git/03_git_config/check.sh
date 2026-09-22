#!/bin/sh

# Run the checks from the world's home rather than from inside the Factory
# repository: the identity has to be set for the whole world, not only for one
# repository.  Later missions recreate the Factory from scratch, and a
# repository-local identity would be lost with it.
cd "$GSH_HOME"

if ! git config --get user.name > /dev/null 2>&1
then
    echo "$(gettext "You did not setup your name correctly")"
    if git -C "$GSH_HOME/Factory" config --local --get user.name > /dev/null 2>&1
    then
        echo "$(gettext "You set it for the Factory repository only. Use the --global option so that it applies to every repository.")"
    fi
    false
elif ! git config --get user.email > /dev/null 2>&1
then
    echo "$(gettext "You did not setup your email correctly")"
    if git -C "$GSH_HOME/Factory" config --local --get user.email > /dev/null 2>&1
    then
        echo "$(gettext "You set it for the Factory repository only. Use the --global option so that it applies to every repository.")"
    fi
    false
else
    true
fi
