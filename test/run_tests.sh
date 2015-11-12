#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
STARTTIME=$(date +%s)
set -e

echo "+++ Run the goss tests"

cd $DIR/../local/tests
TESTS=$(find . | grep '/goss_hotrod/' | grep -e '\.json$')
for t in $TESTS; do
  echo 
  echo "+++ Running test: $t"
  cat $t | docker-machine ssh $BKHOTROD 'goss validate'
done

TESTS=$(find . | grep '/goss_easyelk/' | grep -e '\.json$')
for t in $TESTS; do
  echo 
  echo "+++ Running test: $t"
  cat $t | docker-machine ssh $BKHOTROD 'goss validate'
done
