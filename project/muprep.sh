#!/bin/bash
set -e 

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

repos=$(ls -1d */ | tr '/' ' ')
for i in ${repos}
do
   echo "HOTROD>> git" "$@" "$i"
   mu register $i
done
