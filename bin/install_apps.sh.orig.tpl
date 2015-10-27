#!/bin/bash

# This script will be seeded from mini.py run
# It searches for apps in the project.yml file and install them

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
STARTTIME=$(date +%s)
cd $DIR/../local



{% for app in apps -%}
git clone {{ app.repo }} {{ app.dest }}
{% endfor %}



