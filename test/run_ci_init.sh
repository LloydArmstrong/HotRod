#!/bin/bash

set -e

export HOTROD_PROJNAME=Hotrod
export HOTROD_HOSTNAME=$(docker-machine ip bkhotrod)
export NOPROMPT=Yes

./hotrod init


