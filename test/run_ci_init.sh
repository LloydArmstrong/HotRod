#!/bin/bash

set -eo pipefail

PROJNAME=$(echo $BUILDKITE_PROJECT_SLUG | cut -f2 -d'/')
BKHOTROD=$PROJNAME-bkhotrod-$BUILDKITE_BUILD_NUMBER

export HOTROD_PROJNAME=Hotrod
export HOTROD_HOSTNAME=$(docker-machine ip $BKHOTROD)
export NOPROMPT=Yes

eval $(docker-machine env $BKHOTROD)

echo "--- Log on to Docker Hub"
[ -n "DOCKER_HUB_USERNAME" ] && {
  docker login \
  -e $DOCKER_HUB_EMAIL \
  -p $DOCKER_HUB_PASSWORD \
  -u $DOCKER_HUB_USERNAME
}

echo "+++ Run HotRod Init"

./hotrod init


