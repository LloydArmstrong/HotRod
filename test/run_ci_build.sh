#!/bin/bash

# Check if there are existing machines...
CANDIDATES=$(docker-machine ls -q | grep bkhotrod)

set -e

[ -n "$CANDIDATES" ] && {
  docker-machine rm $CANDIDATES
  sleep 30
}

./bin/do_machine.sh create bkhotrod Hotrod

