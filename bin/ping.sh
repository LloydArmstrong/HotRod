#!/bin/bash

me=`basename $0`
pwd=$(basename `pwd`)
echo "This is $pwd/$me" 1>&2
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
HOTROD_ROOT="$( cd $DIR/../.. && pwd )"

cd $DIR

set -o noglob
SALT='time salt-ssh * --max-procs=20 -i -l info --hard-crash '

$SALT -r 'echo hello'

