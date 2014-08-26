#!/bin/bash
set -e

EXTERNAL_IP=$(curl http://v4.ident.me 2>/dev/null)
RET=$?
echo "$DATE EIP=$EXTERNAL_IP RET=$RET"
SHOSTED=$(ifconfig | grep ${EXTERNAL_IP})

docker build -t panoptix/hotrod .

if [ $1 ]; then
  docker run --name hotrod -it --rm -v /var/run/docker.sock:/var/run/docker.sock panoptix/hotrod 
else 
  echo " " 
  echo "Welcome."
  echo " "
  echo "About to bootstrap HotRod with IP: ${EXTERNAL_IP}"
  echo "After initialisation (may take several minutes), access HotRod on https://${EXTERNAL_IP}"
  echo " "
  echo "--- press CTRL-C to abort, Return to continue ---"
  read
  docker run --name hotrod -it --rm -v /var/run/docker.sock:/var/run/docker.sock panoptix/hotrod ./up.sh $EXTERNAL_IP
fi

