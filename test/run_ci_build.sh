#!/bin/bash

set -e

# Check if there are existing machines...
CANDIDATES=$(docker-machine ls -q | grep bkhotrod)
[ -n "$CANDIDATES" ] && {
  docker-machine rm $CANDIDATES
}

./bin/do_machine.sh create bkhotrod Hotrod
