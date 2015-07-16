#!/bin/bash

# Check if there are existing machines...

echo "--- check if bkhotrod machine exists"

CANDIDATES=$(docker-machine ls -q | grep bkhotrod)

set -e

[ -n "$CANDIDATES" ] && {
  echo "--- remove machines $CANDIDATES"
  docker-machine rm $CANDIDATES
  sleep 30
}

echo "+++ create machine bkhotrod Hotrod"
./bin/do_machine.sh create bkhotrod Hotrod

