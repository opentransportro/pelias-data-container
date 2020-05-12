#!/bin/bash

# errors should break the execution
set -e

# Download gtfs stop data

echo 'Loading GTFS data from api.opentransport.ro...'

URL="http://api.opentransport.ro/routing-data/v1/"
SERVICE="romania/"
NAME="router-romania.zip"
cd $DATA
curl -sS -O --fail $URL$SERVICE$NAME
unzip -o $NAME && rm $NAME

echo '##### Loaded GTFS data'
