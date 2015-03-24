#!/bin/bash

me=`basename $0`
pwd=$(basename `pwd`)
echo "This is $pwd/$me" 1>&2
set -e
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DIR=$DIR/..
cd $DIR

time salt-ssh \* -l info state.sls cluster.build 
time salt-ssh \* -l info state.sls cluster.run 
time salt-ssh \* -l info state.sls cluster.network
time salt-ssh \* -l info service.restart salt-minion

