#!/bin/bash

set -e

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

usage() {
    echo "This script creates machines on Digital Ocean, and sets the correct Docker labels for the Docker Engine."
    echo ""
    echo "Usage:"
    echo " create MYMACHINENAME MYHOTRODPROJECT"
    echo ""
    echo ""
    echo "Env Variables supported:"
    echo "  DIGITALOCEAN_ACCESS_TOKEN"
    echo "  DIGITALOCEAN_REGION"
    echo "  DIGITALOCEAN_SIZE"    
    echo ""
    exit 1
}

COMMAND=$1

[ $# -gt 0 ] || usage

shift 1

[  ! -n "$DIGITALOCEAN_ACCESS_TOKEN" ] && {
   echo "Please set the DIGITALOCEAN_ACCESS_TOKEN environment variable before continuing"
   exit 1
}

create() {

  SWARM_TOKEN=$(docker run --rm swarm create)
  SWARM_FLAGS="--swarm --swarm-discovery=token://${SWARM_TOKEN}"
  SWARM_NUMBER=$3
  
  [ -n "$DIGITALOCEAN_REGIONS" ] || export DIGITALOCEAN_REGION=ams3
  [ -n "$DIGITALOCEAN_SIZE" ] || export DIGITALOCEAN_SIZE=512mb  
  if [[ "$2" != "" ]]; then 
    export HOTROD_PROJ=$2
  else 
    export HOTROD_PROJ=Hotrod
  fi

  read -a REGIONS <<<$DIGITALOCEAN_REGIONS
  LEN=${#REGIONS[@]}

  echo "DIGITALOCEAN_REGIONS   = $DIGITALOCEAN_REGIONS ($LEN)"
  echo "DIGITALOCEAN_SIZE      = $DIGITALOCEAN_SIZE"
  echo "HOTROD_PROJECT         = $HOTROD_PROJ"
  echo "HOTROD_CLUSTER_SIZE    = $SWARM_NUMBER"  
  
  for i in $(seq 1 $SWARM_NUMBER);
  do
    REGION_SELECTED=${REGIONS[$(n=${i} && echo $(( n %= $LEN )))]}
    SWARM_NODE_NAME="${1}-${i}"
    echo "Creating node: $i in region $REGION_SELECTED"    
    DIGITALOCEAN_REGION=$REGION_SELECTED
    if [ ${i} = '1' ]; then
      echo "$SWARM_NODE_NAME is master"
      set -x
      docker-machine create -d digitalocean \
      ${SWARM_FLAGS} \
      --swarm-master \
      --engine-label "za.co.panoptix.Hotrod=True" \
      --engine-label "za.co.panoptix.HotrodProj=$HOTROD_PROJ" \
      --engine-label "za.co.panoptix.manage.port=tcp://127.0.0.1:12345" \
      ${SWARM_NODE_NAME}
      set +x      
    else
      set -x
      echo "Create $SWARM_NODE_NAME"
      docker-machine create -d digitalocean \
      ${SWARM_FLAGS} \
      --engine-label "za.co.panoptix.Hotrod=True" \
      --engine-label "za.co.panoptix.HotrodProjRef=$HOTROD_PROJ" \
      --engine-label "za.co.panoptix.manage.port=tcp://127.0.0.1:12345" \
      ${SWARM_NODE_NAME}
      set +x      
    fi
  done
}


case "$COMMAND" in
    create)
        create $1 $2 $3
        ;;
    *)
        echo "Unknown command '$COMMAND'" >&2
        usage
        ;;
esac
 
