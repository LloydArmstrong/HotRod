#!/bin/bash
set -e

HOTROD_URL="$1"

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

export HOTROD_URL

echo " "
echo "Welcome."
echo " "
echo "About to bootstrap HotRod with : ${HOTROD_URL}"
echo "After initialisation (may take several minutes), access HotRod on ${HOTROD_URL}"
echo " "
echo "--- press CTRL-C to abort, Return to continue ---"
read

python /tmp/mini-templates/mini.py
cd logger
fig -p hotrodlogger build
fig -p hotrodlogger up
~            
