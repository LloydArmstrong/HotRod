#!/bin/bash

set -eo pipefail

BKHOTROD=bkhotrod-$BUILDKITE_BUILD_NUMBER

echo "+++ destroy $BKHOTROD machine"
docker-machine rm -f 

echo "--- done"