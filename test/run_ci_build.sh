#!/bin/bash

PROJNAME=$(echo $BUILDKITE_PROJECT_SLUG | cut -f2 -d'/')
BKHOTROD=$PROJNAME-bkhotrod-$BUILDKITE_BUILD_NUMBER

export DIGITALOCEAN_ACCESS_TOKEN=$(vault read -field=token secret/CD/cloud/DigitalOceanCI)
export DIGITALOCEAN_REGION=$(vault read -field=region secret/CD/cloud/DigitalOceanCI/region)

echo "--- check if $BKHOTROD machine exists"

CANDIDATES=$(docker-machine ls -q | grep $PROJNAME-bkhotrod)

set -e

[ -n "$CANDIDATES" ] && {
  echo "--- remove machines $CANDIDATES"
  docker-machine rm $CANDIDATES
  sleep 30
}

[ -n "$HOTROD_PROJECT" ] || {
  echo "You must define HOTROD_PROJECT"
  exit 1
}

echo "+++ create machine $BKHOTROD Hotrod"
./bin/do_machine.sh create $BKHOTROD Hotrod

echo "+++ seed fake/empty default.yml"
cat > default.yml << EOF
variables:
  hotrod_project_name: EasyELK

collect:
  - regex: dc-\d{2}.+\.orig\.tpl
    dst: docker-compose.yml

EOF

# Determine platform
case "$(uname)" in
    Darwin)
        BASE64CMD='base64 -D '
        ;;
     Linux)
        BASE64CMD='base64 -d '
        ;;
esac 

declare -a FILES=("local/project.yml")

VAULT_PREFIX="secret/CD/var/projects"
VAULT_PATH="$VAULT_PREFIX/$HOTROD_PROJECT"

for file in "${FILES[@]}"
do
  echo "+++ seed $file"
  FILECONTENTS=$(vault read -field=payload $VAULT_PATH/file/$file) 
  TARGET=$file
  mkdir -p $(dirname $TARGET)
  echo $FILECONTENTS | $BASE64CMD > $TARGET
done
