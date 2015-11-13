#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
STARTTIME=$(date +%s)
set -e

if [ ! -n "$DOCKERMACHINE" ]; then
  export PROJNAME=$(echo $BUILDKITE_PROJECT_SLUG | cut -f2 -d'/')
  export BKHOTROD=$PROJNAME-bkhotrod-$BUILDKITE_BUILD_NUMBER
else
  export BKHOTROD=$DOCKERMACHINE
fi

[ -n "$BKHOTROD" ] || {
  echo "A docker-machine must be defined..."
  exit 1
}

echo "+++ Install Goss if needed"
docker-machine ssh $BKHOTROD 'test -f /usr/local/bin/goss || curl -L https://github.com/aelsabbahy/goss/releases/download/v0.0.15/goss-linux-amd64 > /usr/local/bin/goss && chmod +x /usr/local/bin/goss'

echo "+++ Run the goss tests"
cd $DIR/../local/tests
TESTS=$(find . | grep '/goss_hotrod/' | grep -e '\.json$')
for t in $TESTS; do
  echo 
  echo "+++ Running test: $t"
  cat $t | docker-machine ssh $BKHOTROD 'goss validate'
done

TESTS=$(find . | grep -v '/goss_hotrod/' | grep -e '\.json$')
for t in $TESTS; do
  echo 
  echo "+++ Running test: $t"
  cat $t | docker-machine ssh $BKHOTROD 'goss validate'
done
