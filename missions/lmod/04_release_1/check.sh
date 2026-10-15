#!/usr/bin/env sh

version=`python --version 2>&1 | awk '{print $NF}' | tr "." "\n"| head -n1`
echo "Detected Python major version: $version"
if [ "$version" = "2" ]
then
    unset goal anscommit uniq_version
    true
else
	echo "$(gettext "Looks like this is not Python 2. If you just did 'module load Python', it is likely that you loaded a newer version (Python 3), which is also available here.")"
    echo "$(gettext "Please retry.")"
    false
fi
