#!/bin/bash

set -eo pipefail

PROJNAME=$(echo $BUILDKITE_PROJECT_SLUG | cut -f2 -d'/')
BKHOTROD=$PROJNAME-bkhotrod-$BUILDKITE_BUILD_NUMBER

[ -n "$HOTROD_KEEPMACHINE" ] || {
  echo "+++ destroy $BKHOTROD machine"
  docker-machine rm -f $BKHOTROD
}

echo "--- done"

