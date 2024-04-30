#!/usr/bin/env bash -x


if [[ ! -d $GSH_HOME/testjob ]] ; then
    echo "The directory testjob is not present at the root of the hierarchy."
    return 1
fi

if [[ ! -f $GSH_HOME/testjob/submit.sh ]] ; then
    echo "The file submit.sh is not present in the testjob directory."
    return 1
fi

if cat $GSH_HOME/testjob/submit.sh | head -1 | grep "#!" &>/dev/null
then
    true
else
    echo "The submit.sh file is not correct. It should start with a shebang"
    echo "e.g. #!/bin/bash"
    false
fi
