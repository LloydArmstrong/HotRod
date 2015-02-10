#!/bin/bash

me=`basename $0`
pwd=$(basename `pwd`)
echo "This is $pwd/$me" 1>&2
set -e
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DIR=$DIR/..
cd $DIR

time salt-ssh \* state.sls cluster.build 
time salt-ssh \* state.sls cluster.run 
time salt-ssh \* state.sls cluster.network
