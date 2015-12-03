#!/bin/bash

echo "--- seed fake/empty default.yml"
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

set -x

for file in "${FILES[@]}"
do
  echo "--- seed $file"
  set +x
  FILECONTENTS=$(vault read -field=payload $VAULT_PATH/file/$file) 
  TARGET=$file
  mkdir -p $(dirname $TARGET)
  echo $FILECONTENTS | $BASE64CMD > $TARGET
  set -x
  ls -l $file
done

