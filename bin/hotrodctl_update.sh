#!/bin/bash

me=`basename $0`
pwd=$(basename `pwd`)
echo "This is $pwd/$me" 1>&2
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DIR=$DIR/..
cd $DIR

set -o noglob
SALT='time salt-ssh * --max-procs=20 -i -l info --hard-crash '

# $SALT -r 'sudo rm -f /etc/salt/pki/minion/minion_master.pub'
# $SALT -r 'sudo service salt-minion restart'
$SALT -r 'sudo /usr/local/bin/hotrodctl update'
