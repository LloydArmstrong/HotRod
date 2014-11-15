#!/bin/bash

me=`basename $0`
pwd=$(basename `pwd`)
echo "This is $pwd/$me" 1>&2
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DIR=$DIR/..
cd $DIR

OUT="salt/roster"

# Get VMS
RESULT=$(salt-cloud -c salt/ -F --out=yaml 2>/dev/null)
echo "$RESULT" > salt/cacheinventory
echo "$RESULT" 1>&2

PROVIDERS=$(echo "$RESULT" | shyaml keys)

#if [[ "$PROVIDERS" != "{}" ]]; then
  [ -f $OUT ] && rm $OUT
#fi 
set +e
for PROVIDER in $PROVIDERS; do
P1=$(find . | grep conf | grep providers | xargs cat | shyaml get-value $PROVIDER.provider)
echo "P1: $P1"

MAPS=$(find . | grep cloud.maps.d | grep '.map$')
PROFILES=$( 
for M in $MAPS; do 
  KEYS=$(cat $M | shyaml keys);
  for KEY in $KEYS; do
    SERVERS=$(cat $M | shyaml get-values $KEY)
    for S in $SERVERS; do
      PFILES=$(find . | grep cloud.profiles.d | grep '.conf$')
      for PFILE in $PFILES; do
       USER=$(cat $PFILE | shyaml get-value $KEY.ssh_username)
       SUDO=$(cat $PFILE | shyaml get-value $KEY.ssh_sudo)
       if [[ "$USER" != "" ]]; then
         echo "$S,$USER,$SUDO,$PFILE,$KEY,$M"                    
       fi
      done
    done
  done
done)

echo "$PROFILES"

VMS=$(cat salt/cacheinventory | shyaml keys $PROVIDER.$P1)
VMS=$(echo "$VMS" | grep -v "^$")
if [[ $VMS == *' '* ]]; then
VMS=$(echo "$VMS" | awk '{ print $2; }' | sed "s/'//g")
fi
VMS=$(echo "$VMS" | grep -v -f ./localonly-exclude)
echo "$VMS"

for VM in $VMS; do
  if [[ $VM == *master* ]]; then
     IP=$(echo "$RESULT" | shyaml get-value $PROVIDER.$P1.$VM.public_ips.0)
     if [[ "$IP" == "" ]]; then 
       IP=$(echo "$RESULT" | shyaml get-value $PROVIDER.$P1.$VM.ip_address)
     fi 
     MASTER=$IP
  fi
done
mkdir -p salt/master.d
echo "" > salt/master.d/weave.conf
echo "ssh_grains:" >> salt/master.d/weave.conf
echo "   weave_master_ip: $MASTER"  >> salt/master.d/weave.conf

for VM in $VMS; do
  echo "Generating: $VM"
  IP=$(echo "$RESULT" | shyaml get-value $PROVIDER.$P1.$VM.public_ips.0)
  if [[ "$IP" == "" ]]; then 
    IP=$(echo "$RESULT" | shyaml get-value $PROVIDER.$P1.$VM.ip_address)
  fi 
  echo "IP: $IP"
  WEAVE=$(echo $VM | cut -d'-' -s -f2,3 | sed 's/-/\./')
  USERNAME=$(echo "$PROFILES" | grep "^$VM" | cut -d"," -f 2)
  SUDO=$(echo "$PROFILES" | grep "^$VM" | cut -d"," -f 3)  
  echo "$VM:" >> $OUT
  echo "   host: $IP" >> $OUT
  echo "   user: $USERNAME" >> $OUT
  echo "   sudo: $SUDO" >> $OUT
  echo "   grains:" >> $OUT
  echo "     weave_num: $( echo $WEAVE | cut -d'.' -f2)" >> $OUT
  echo "     weave_sub: $( echo $WEAVE | cut -d'.' -f1)" >> $OUT
  echo "     weave_ip: 10.0.$WEAVE" >> $OUT
  echo "" >> $OUT
done

done

cat $OUT
