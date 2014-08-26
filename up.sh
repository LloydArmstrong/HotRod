#!/bin/bash
set -e

hotrodurl="$1"
export hotrodurl

python /tmp/mini-templates/mini.py
cd logger
fig build
fig up
