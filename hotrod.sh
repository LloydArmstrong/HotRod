#!/bin/bash

set -e 

docker build -t panoptix/hotrod .

if [[ "$1" == "shell" ]]; then
  docker run --name hotrod -it --rm -v /var/run/docker.sock:/var/run/docker.sock panoptix/hotrod 
else 
  docker run --name hotrod -it --rm -v /var/run/docker.sock:/var/run/docker.sock panoptix/hotrod ./up.sh $HOTROD_URL
fi

