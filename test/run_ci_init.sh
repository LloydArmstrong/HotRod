#!/bin/bash

set -eo pipefail

PROJNAME=$(echo $BUILDKITE_PROJECT_SLUG | cut -f2 -d'/')
BKHOTROD=$PROJNAME-bkhotrod-$BUILDKITE_BUILD_NUMBER

export HOTROD_PROJNAME=Hotrod-$PROJNAME
export HOTROD_HOSTNAME=$(docker-machine ip $BKHOTROD)
export NOPROMPT=Yes
export ADMIN_PASSWD=$(vault read -field=admin secret/CD/cloud/TestCredentials)
export DEFAULT_USER_PASSWD=$(vault read -field=default secret/CD/cloud/TestCredentials)
export DOCKER_HUB_USERNAME=$(vault read -field=username secret/CD/cloud/DockerCI)
export DOCKER_HUB_PASSWORD=$(vault read -field=password secret/CD/cloud/DockerCI)
export DOCKER_HUB_EMAIL=$(vault read -field=email secret/CD/cloud/DockerCI)

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
