#!/bin/bash -e

[ ! -n "$1" ] && {
  echo "Specifying a prefix for the docker-machines is mandatory"
  exit 1
}

DOCKER_MACHINE_PREFIX=${1:-"swarm"}
HOTROD_CLUSTER_SIZE=${HOTROD_CLUSTER_SIZE:-"3"}


DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
STARTTIME=$(date +%s)
cd $DIR

declare -a TOOLS=("docker" "docker-machine")
# utility function to check whether a command can be executed by the shell
# see http://stackoverflow.com/questions/592620/how-to-check-if-a-program-exists-from-a-bash-script
command_exists () {
    command -v $1 >/dev/null 2>&1
}

for cmd in "${TOOLS[@]}"
do
  echo "Checking for dependencies... ($cmd)"
  command_exists $cmd
  echo "$cmd (present)"
done

driver_flags="--driver ${DOCKER_MACHINE_DRIVER}"

read -a REGIONS <<<$DIGITALOCEAN_REGIONS
LEN=${#REGIONS[@]}

echo "DOCKER_MACHINE_PREFIX      = $DOCKER_MACHINE_PREFIX"
echo "HOTROD_CLUSTER_SIZE        = $HOTROD_CLUSTER_SIZE"
echo ""
for i in $(seq $HOTROD_CLUSTER_SIZE) ; do
  VARNAME="SWARM_${i}_OPTIONS"
  eval MACHINE_OPTIONS=\$$VARNAME
  [[ "$MACHINE_OPTIONS" != "" ]] && echo "SWARM_${i}_OPTIONS            = $MACHINE_OPTIONS"
done
echo ""
echo "Press Ctrl+C to abort in the next 5 seconds"
sleep 5

set +e
for i in $(seq $HOTROD_CLUSTER_SIZE) ; do
  SWARM_NODE_NAME="${DOCKER_MACHINE_PREFIX}-${i}"
  ## This environment variable is respected by Weave script,
  ## hence it needs to be exported
  export DOCKER_CLIENT_ARGS="$(docker-machine config $SWARM_NODE_NAME)"

  docker ${DOCKER_CLIENT_ARGS} rm -f weave weaveproxy

done
set -e

unset DOCKER_CLIENT_ARGS

