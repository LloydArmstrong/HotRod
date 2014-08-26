#!/bin/bash

if [[ "$HOTROD_URL" == "" ]]; then
  EXTERNAL_IP=$(curl http://v4.ident.me 2>/dev/null)
  RET=$?
  echo "EXTERNAL_IP=$EXTERNAL_IP RET=$RET"
  SHOSTED=$(ifconfig | grep ${EXTERNAL_IP})
  FOUND="$?"

  if [[ "$FOUND" != "0" && "$RET" == "0" ]]; then
    echo "Not publicly hosted, auto bootstrap needs input."
    echo "Please set environment variable HOTROD_URL"
    exit 1
  else
    HOTROD_URL="https://${EXTERNAL_IP}"
  fi
fi

if [[ $HOTROD_URL != *https* ]]; then
  echo "Aborting, URL does not contain https://, HotRod was designed to work with https."
  exit 1
fi 

set -e 

docker build -t panoptix/hotrod .

if [[ "$1" == "shell" ]]; then
  docker run --name hotrod -it --rm -v /var/run/docker.sock:/var/run/docker.sock panoptix/hotrod 
else 
  echo " " 
  echo "Welcome."
  echo " "
  echo "About to bootstrap HotRod with : ${HOTROD_URL}"
  echo "After initialisation (may take several minutes), access HotRod on ${HOTROD_URL}"
  echo " "
  echo "--- press CTRL-C to abort, Return to continue ---"
  read
  docker run --name hotrod -it --rm -v /var/run/docker.sock:/var/run/docker.sock panoptix/hotrod ./up.sh $EXTERNAL_IP
fi

