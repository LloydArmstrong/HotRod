#!/bin/bash

set -eo pipefail

export HOTROD_PROJNAME=Hotrod
export HOTROD_HOSTNAME=$(docker-machine ip bkhotrod)
export NOPROMPT=Yes

echo "--- Log on to Docker Hub"

[ -n "DOCKER_HUB_USERNAME" ] && {
  docker login \
  -e $DOCKER_HUB_EMAIL \
  -p $DOCKER_HUB_PASSWORD \
  -u $DOCKER_HUB_USERNAME
}

echo "+++ Run Docker Init"

./hotrod init


