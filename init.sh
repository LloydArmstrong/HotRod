#!/bin/bash

# Run this script to get the initial repos prepped, as well as generate the custom config 
# files

set -e 

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

# Grab the latest hotrod-composition for our git server
echo "HotRod Composition..."
[ -d $DIR/cloudops/srv/external/git ] || {
  mkdir $DIR/cloudops/srv/external/git
  cd $DIR/cloudops/srv/external/git
  git clone --bare https://bitbucket.org/hotrodcore/hotrod-composition.git hotrod-composition.git 
  }

[ -d $DIR/project/hotrod ] || {
  cd $DIR/project
  git clone $DIR/cloudops/srv/external/git/hotrod-composition.git hotrod
}

[ -d $DIR/cloudops/srv/hotrod ] || {
  cd $DIR/cloudops/srv
  ln -s $DIR/project/hotrod
}

[ -d $DIR/cloudops/srv/local ] || {
  cd $DIR/cloudops/srv
  ln -sf $DIR/local 
}

[ -d $DIR/cloudops/srv/project ] || {
  cd $DIR/cloudops/srv
  ln -sf $DIR/project
}

cd $DIR
echo "Done..."



