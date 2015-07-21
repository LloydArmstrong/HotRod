#!/bin/bash

cat ~/.ssh/ourkeys | docker-machine ssh $BKHOTROD 'cat >> .ssh/authorized_keys && echo "Key copied"'
