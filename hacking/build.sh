#!/bin/bash
set -e 

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source $DIR/repos

for i in "${projects[@]}"
do
   cd $DIR/masters/$i
   DOCKERTAG=$(echo $i | sed  's/docker-//')
   echo "HOTROD>> docker build -t panoptix/$DOCKERTAG ."
   docker build -t panoptix/$DOCKERTAG .
done
