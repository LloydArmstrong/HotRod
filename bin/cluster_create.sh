#!/bin/bash -e

DOCKER_MACHINE_PREFIX=${1:-"swarm"}
HOTROD_PROJECT=${HOTROD_PROJECT:-"HotRod"}
DIGITALOCEAN_REGIONS=${DIGITALOCEAN_REGIONS:-"ams3"}
export DIGITALOCEAN_SIZE=${DIGITALOCEAN_SIZE:-"4gb"}
HOTROD_CLUSTER_SIZE=${HOTROD_CLUSTER_SIZE:-"3"}
DOCKER_MACHINE_DRIVER=${DOCKER_MACHINE_DRIVER:-"virtualbox"}
[ -e "$WEAVE_PASSWORD" ] || {
  WEAVE_PASSWORD=$(openssl rand -base64 32)
}

HOTROD_FLAGS="--engine-label za.co.panoptix.Hotrod=True --engine-label za.co.panoptix.HotrodProj=$HOTROD_PROJECT"

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

echo "DOCKER_MACHINE_DRIVER      = $DOCKER_MACHINE_DRIVER"
[[ "$DOCKER_MACHINE_DRIVER" == "digitalocean" && ! -n "$DIGITALOCEAN_ACCESS_TOKEN" ]] && {
   echo "Please set the DIGITALOCEAN_ACCESS_TOKEN environment variable before continuing"
   exit 1
}
echo "DOCKER_MACHINE_PREFIX      = $DOCKER_MACHINE_PREFIX"
echo "DIGITALOCEAN_REGIONS       = $DIGITALOCEAN_REGIONS ($LEN)"
echo "DIGITALOCEAN_SIZE          = $DIGITALOCEAN_SIZE"
echo "HOTROD_PROJECT             = $HOTROD_PROJECT"
echo "HOTROD_CLUSTER_SIZE        = $HOTROD_CLUSTER_SIZE"
echo "WEAVE_PASSWORD (save this) = $WEAVE_PASSWORD"
echo ""
for i in $(seq $HOTROD_CLUSTER_SIZE) ; do
  VARNAME="SWARM_${i}_OPTIONS"
  eval MACHINE_OPTIONS=\$$VARNAME
  [[ "$MACHINE_OPTIONS" != "" ]] && echo "SWARM_${i}_OPTIONS            = $MACHINE_OPTIONS"
done
echo ""
echo "Press Ctrl+C to abort in the next 5 seconds"
sleep 5

## I am using curl to create tokens as I find it the easiest, otherwise
## one needs to either download or compile a `docker-swarm` binary or
## have a Docker daemon running
echo "Querying for Swarm token..."
DOCKER_SWARM_CREATE=${DOCKER_SWARM_CREATE:-"curl -s -XPOST https://discovery-stage.hub.docker.com/v1/clusters"}

swarm_flags="--swarm --swarm-discovery=token://$(${DOCKER_SWARM_CREATE})"

for i in $(seq $HOTROD_CLUSTER_SIZE) ; do
  [[ "$DOCKER_MACHINE_DRIVER" == "digitalocean" ]] && {
    REGION_SELECTED=${REGIONS[$(n=${i} && echo $(( n %= $LEN )))]}
    export DIGITALOCEAN_REGION=$REGION_SELECTED
    echo "Digital Ocean Region select: ${DIGITALOCEAN_REGION}"
  }
  SWARM_NODE_NAME="${DOCKER_MACHINE_PREFIX}-${i}"
  echo "Creating node: $SWARM_NODE_NAME"

  [ ! -e "SWARM_${i}_OPTIONS" ] && {
    VARNAME="SWARM_${i}_OPTIONS"
    eval MACHINE_OPTIONS=\$$VARNAME
  }
  set +e
  if [ ${i} = 1 ]; then
    ## The first machine shall be the Swarm master
    docker-machine create \
      ${driver_flags} \
      ${swarm_flags} \
      ${HOTROD_FLAGS} \
      ${MACHINE_OPTIONS} \
      --engine-label "za.co.panoptix.HotrodIndex=${i}" \
      --swarm-master \
      $SWARM_NODE_NAME &
  else
    ## The rest of machines are Swarm slaves
    docker-machine create \
      ${driver_flags} \
      ${swarm_flags} \
      ${HOTROD_FLAGS} \
      ${MACHINE_OPTIONS} \
      --engine-label "za.co.panoptix.HotrodIndex=${i}" \
      $SWARM_NODE_NAME &
  fi
  set -e
done

wait
unset DIGITALOCEAN_REGION

echo "All $HOTROD_CLUSTER_SIZE complete"

find_tls_args="cat /etc/default/docker | grep ^--tl | tr '\n' ' '"

set +e
for i in $(seq $HOTROD_CLUSTER_SIZE) ; do
  SWARM_NODE_NAME="${DOCKER_MACHINE_PREFIX}-${i}"
  ## This environment variable is respected by Weave script,
  ## hence it needs to be exported
  export DOCKER_CLIENT_ARGS="$(docker-machine config $SWARM_NODE_NAME)"

  tlsargs=$(docker-machine ssh "$SWARM_NODE_NAME" "${find_tls_args}")

  ## We are going to use IPAM, hence we supply estimated cluster size
  ./weave launch-router --password $WEAVE_PASSWORD --init-peer-count $HOTROD_CLUSTER_SIZE
  ## Proxy will use TLS arguments we just obtained from Docker
  ./weave launch-proxy ${tlsargs}

  ## Let's connect-up the Weave cluster by telling
  ## each of the nodes about the head node (${DOCKER_MACHINE_PREFIX}-1)
  if [ ${i} -gt 1 ] ; then
    ./weave connect $(docker-machine ip "${DOCKER_MACHINE_PREFIX}-1")
  fi
done
set -e

unset DOCKER_CLIENT_ARGS

DOCKER_SWARM_CREATE=${DOCKER_SWARM_CREATE:-"curl -s -XPOST https://discovery-stage.hub.docker.com/v1/clusters"}

## This script will replace Swarm agent, aside from that it will have
## point them to Weave proxy port 12375 instead of Docker port 2376,
## it will need a new token as the registration on Docker Hub stores
## an array of `<host>:<port>` pairs and the clean-up method doesn't
## seem to be documented
swarm_discovery_token="$(${DOCKER_SWARM_CREATE})"

set +e
for i in $(seq $HOTROD_CLUSTER_SIZE | sort -r) ; do
  SWARM_NODE_NAME="${DOCKER_MACHINE_PREFIX}-${i}"

  ## We are not really using Weave script anymore, hence
  ## this is only a local variable
  DOCKER_CLIENT_ARGS="$(docker-machine config $SWARM_NODE_NAME)"

  ## Default Weave proxy port is 12375
  weave_proxy_endpoint="$(docker-machine ip $SWARM_NODE_NAME):12375"

  ## Next, we restart the slave agents
  docker ${DOCKER_CLIENT_ARGS} rm -f swarm-agent
  docker ${DOCKER_CLIENT_ARGS} run \
    -d \
    --restart=always \
    --name=swarm-agent \
    swarm join \
    --addr "${weave_proxy_endpoint}" \
    "token://${swarm_discovery_token}"

  if [ ${i} = 1 ] ; then
    ## On the head node (${DOCKER_MACHINE_PREFIX}-1) we will also restart the master
    ## with the new token and all the original arguments; the reason
    ## this is a bit complicated is because we need steal all the
    ## `--tls*` arguments as well as the `-v` ones
    swarm_master_args_fmt="\
      -d \
      --restart=always \
      --name={{.Name}} \
      -p 3376:3376 \
      {{range .HostConfig.Binds}}-v {{.}} {{end}} \
      swarm{{range .Args}} {{.}}{{end}} \
    "
    swarm_master_args=$(docker ${DOCKER_CLIENT_ARGS} inspect \
        --format="${swarm_master_args_fmt}" \
        swarm-agent-master \
        | sed "s|\(token://\)[[:alnum:]]*|\1${swarm_discovery_token}|")

    docker ${DOCKER_CLIENT_ARGS} rm -f swarm-agent-master
    docker ${DOCKER_CLIENT_ARGS} run ${swarm_master_args}
  fi
done
set -e