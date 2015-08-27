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
    echo "  GEN_USERNAME"
    echo "  GEN_HOSTNAME"
    echo "  GEN_SSHPUBKEY"    
    echo "  GEN_OPTIONS"
    echo ""
    exit 1
}

COMMAND=$1

[ $# -gt 0 ] || usage

shift 1

# [  ! -n "$DIGITALOCEAN_ACCESS_TOKEN" ] && {
#    echo "Please set the DIGITALOCEAN_ACCESS_TOKEN environment variable before continuing"
#    exit 1
# }

create() {
  echo ""
  echo "Creating $1"
  [ -n "$GEN_USERNAME" ] || {
    echo "Please set GEN_USERNAME (username) in environment"
    exit 1
  }
  [ -n "$GEN_HOSTNAME" ] || {
    echo "Please set GEN_HOSTNAME (hostname or IP ) in environment"
    exit 1
  }  
  [ -n "$GEN_SSHPUBKEY" ] || {
    echo "Please set GEN_SSHPUBKEY (full path to pub ssh key) in environment"
    exit 1
  }    
  if [[ "$2" != "" ]]; then 
    export HOTROD_PROJ=$2
  else 
    export HOTROD_PROJ=Hotrod
  fi

  echo "GEN_USERNAME        = $GEN_USERNAME"
  echo "GEN_HOSTNAME        = $GEN_HOSTNAME"
  echo "HOTROD_PROJECT      = $HOTROD_PROJ"

  set -x
  docker-machine create -d generic \
  --engine-label "za.co.panoptix.Hotrod=True" \
  --engine-label "za.co.panoptix.HotrodProj=$HOTROD_PROJ" \
  --engine-label "za.co.panoptix.manage.port=tcp://127.0.0.1:12345" \
  --generic-ssh-user ${GEN_USERNAME} \
  --generic-ssh-key  ${GEN_SSHPUBKEY} \
  --generic-ip-address ${GEN_HOSTNAME} \
  $1
  set +x
}


case "$COMMAND" in
    create)
        create $1 $2
        ;;
    *)
        echo "Unknown command '$COMMAND'" >&2
        usage
        ;;
esac
 
