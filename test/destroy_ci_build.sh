#!/bin/bash

set -eo pipefail

PROJNAME=$(echo $BUILDKITE_PROJECT_SLUG | cut -f1 -d'/')
BKHOTROD=$bkhotrod-$BUILDKITE_BUILD_NUMBER

echo "+++ destroy $BKHOTROD machine"
docker-machine rm -f $BKHOTROD

echo "--- done"