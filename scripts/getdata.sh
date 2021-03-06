#!/bin/bash

# This script is run inside base docker container to add the geocoding data to ES

# errors should break the execution
set -e

# main Docker script has already created these:
export TOOLS=/mnt/tools
export DATA=/mnt/data
export SCRIPTS=$TOOLS/scripts

# Launch Elasticsearch
cd /root

service elasticsearch start
sleep 60

# download and index
$SCRIPTS/dl-and-index.sh

#shutdown ES in a friendly way
service elasticsearch stop

sleep 5
