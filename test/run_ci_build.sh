#!/bin/bash

PROJNAME=$(echo $BUILDKITE_PROJECT_SLUG | cut -f2 -d'/')
BKHOTROD=$PROJNAME-bkhotrod-$BUILDKITE_BUILD_NUMBER

export DIGITALOCEAN_ACCESS_TOKEN=$(vault read -field=token secret/CD/cloud/DigitalOceanCI)
export DIGITALOCEAN_REGION=fra1

echo "--- check if $BKHOTROD machine exists"

CANDIDATES=$(docker-machine ls -q | grep $PROJNAME-bkhotrod)

set -e

[ -n "$CANDIDATES" ] && {
  echo "--- remove machines $CANDIDATES"
  docker-machine rm $CANDIDATES
  sleep 30
}

echo "+++ create machine $BKHOTROD Hotrod"
./bin/do_machine.sh create $BKHOTROD Hotrod

echo "+++ seed empty default.yml"
cat > default.yml << EOF
variables:
  hotrod_project_name: EasyELK

collect:
  - regex: dc-\d{2}.+\.orig\.tpl
    dst: docker-compose.yml

EOF

echo "+++ seed empty project.yml"
cat > local/project.yml << EOF
variables:
  apps:
    - repo: https://github.com/panoptix-za/hotrod-easyelk.git
      dest: easyELK
    - repo: https://github.com/panoptix-za/goss-tests-oss.git
      dest: tests
EOF

set +e
echo "+++ Install Goss if needed"
docker-machine ssh $BKHOTROD 'test -f /usr/local/bin/goss'
[ $? -eq 1 ] || { 
  echo "Installing Goss"
  docker-machine ssh $BKHOTROD 'curl -L https://github.com/aelsabbahy/goss/releases/download/v0.0.15/goss-linux-amd64 > /usr/local/bin/goss && chmod +x /usr/local/bin/goss'
}
set -e

