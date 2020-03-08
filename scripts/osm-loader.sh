#!/bin/bash

set -e

mkdir -p $DATA/openstreetmap
cd $DATA/openstreetmap

# allow failures so that curl can be retried many times
set +e
for i in $(seq 0 4)
do
    # Download osm data
    curl -sS -O -L --fail https://download.geofabrik.de/europe/romania-latest.osm.pbf
    if [ $? -eq 0 ]; then
        echo '##### Loaded OSM data'
        exit 0
    fi
    sleep 600
done

# exit with an error
exit 1
