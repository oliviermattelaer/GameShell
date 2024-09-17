#!/usr/bin/env sh

command="$(gettext 'charmiglio')"

PIDS=$GSH_TMP/charmiglio.pids

_check() {
    rm -f "$PIDS"

    echo "$(gettext "Let's have a look:")"

    sleep 2

    if [ ! -f "$PIDS" ]
    then
        echo "$(gettext "Mmm... I didn't see anything.")"
        return 1
    fi

    NB=$(cat "$PIDS" | wc -l)
    cat $PIDS
    echo "NB = '$NB'"
    if [ "$NB" -ge 3 ]
    then
        echo "$(gettext "Great, that looked good!")"
        return 0
    elif [ "$NB" -lt 3 ]
    then
        echo "$(eval_gettext "Mmm... I only saw \$NB fireworks. That's not enough.")"
        return 1
    else
        echo "you shouldn't see this!"
        return 1
    fi
}

_check
