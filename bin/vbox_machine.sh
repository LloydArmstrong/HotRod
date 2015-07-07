#!/bin/sh

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
    exit 1
}

COMMAND=$1

[ $# -gt 0 ] || usage

shift 1

create() {
  echo ""
  echo "Creating $1"
  if [[ "$2" != "" ]]; then 
    export HOTROD_PROJ=$2
  else 
    export HOTROD_PROJ=Hotrod
  fi

  echo "HOTROD PROJECT      = $HOTROD_PROJ"
  set -x
  docker-machine create -d virtualbox \
  --engine-label Hotrod=True \
  --engine-label HotrodProj=$HOTROD_PROJ \
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