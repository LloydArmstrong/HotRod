#!/bin/bash

# Run this script to get the initial repos prepped, as well as generate the custom config 
# files

set -e 

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

# Grab the latest hotrod-composition for our git server
echo "HotRod Composition..."
[ -d $DIR/project/hotrod ] || {
  cd $DIR/project
  git clone https://github.com/panoptix-za/hotrod-composition.git hotrod
}

cd $DIR
echo "Done..."



