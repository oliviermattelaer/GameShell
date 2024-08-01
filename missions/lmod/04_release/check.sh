#!/usr/bin/env sh

version=`python --version 2>&1 | awk '{print $NF}' | tr "." "\n"| head -n1`
echo "version detected $version"
if [ "$version" = "2" ]
then
    unset goal anscommit uniq_version
    true
else
	echo "$(gettext "Looks like this is not python2")"
    echo "$(gettext "Please Retry")"
    false
fi
