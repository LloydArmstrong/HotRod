#!/bin/bash
# set -e 

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

source $DIR/repos

for i in "${repos[@]}"
do
   echo "HOTROD>> git" "$@" "$i"
   git "$@" "$i"
done
