#!/bin/bash
set -e

hotrodurl="https://$1"
export hotrodurl

python /tmp/mini-templates/mini.py
cd logger
fig build
fig up
~            
