#!/bin/bash

BKHOTROD=bkhotrod-$BUILDKITE_BUILD_NUMBER
echo "--- check if $BKHOTROD machine exists"

CANDIDATES=$(docker-machine ls -q | grep $BKHOTROD)

set -e

[ -n "$CANDIDATES" ] && {
  echo "--- remove machines $CANDIDATES"
  docker-machine rm $CANDIDATES
  sleep 30
}

echo "+++ create machine $BKHOTROD Hotrod"
./bin/do_machine.sh create $BKHOTROD Hotrod

