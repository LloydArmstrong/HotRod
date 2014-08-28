#!/bin/bash
set -e

if [[ $HOTROD_URL != *https* ]]; then
  echo "Aborting, HOTROD_URL environment variable does not contain https://, HotRod was designed to work with https."
  exit 1
fi 

echo " "
echo "Welcome."
echo " "
echo "About to bootstrap HotRod with HOTROD_URL: ${HOTROD_URL}"
echo "After initialisation (may take several minutes), access HotRod on ${HOTROD_URL}"
echo " "
echo "--- Press only RETURN/ENTER to continue ---"
read CONTINUE

if [[ "$CONTINUE" != "" ]]; then
  exit 0
fi

python /tmp/mini-templates/mini.py
cd core
fig -p hotrodcore build
fig -p hotrodcore up -d
cd ..

cd logger
fig -p hotrodlogger build
fig -p hotrodlogger up -d
