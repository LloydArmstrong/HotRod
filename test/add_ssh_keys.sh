#!/bin/bash

cat ~/.ssh/ourkey| docker-machine ssh $BKHOTROD 'cat >> .ssh/authorized_keys && echo "Key copied"'