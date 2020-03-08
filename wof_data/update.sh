#!/bin/bash

#vTODO: this script is outdated. Wof data has been moved and can be downloaded
# using pelias/whosonfirst download script. Unfortunately data fetched with the
# new tool seems to be broken. For example, localadmin mapping does not work. 

# path where to find wof cloning tool
TOOLS=../

# to install the wof cloning tool:
# git clone https://github.com/whosonfirst/go-whosonfirst-clone.git $TOOLS/wof-clone
# cd $TOOLS/wof-clone
# make deps
# make bin


# Download Whosonfirst admin lookup data
URL=https://dist.whosonfirst.org/bundles
METADIR=$(pwd)/meta/
DATADIR=$(pwd)/data/
mkdir -p $METADIR
mkdir -p $DATADIR

cd $METADIR

admins=( country locality neighbourhood region )

for target in "${admins[@]}"
do
    echo processing $target metadata
    if [ ! -d whosonfirst-data-$target-latest ]
    then
        echo downloading $target metadata
        curl -O --progress-bar -S $URL/whosonfirst-data-$target-latest.tar.bz2
        echo extracting $target
        tar -xf whosonfirst-data-$target-latest.tar.bz2
        rm -rf whosonfirst-data-$target-latest.tar.bz2
    fi
    if [ "$target" != "continent" ]
    then
        pushd whosonfirst-data-$target-latest > /dev/null

        cat whosonfirst-data-$target-latest.csv | grep -v ",RO," > to_remove || true

        head -1 whosonfirst-data-$target-latest.csv > temp && cat whosonfirst-data-$target-latest.csv | grep ",RO," >> temp || true
        mv temp whosonfirst-data-$target-latest.csv
        
        echo "removing unrelated files"
        FILES=$(grep -o -F -E '([0-9/]*).geojson' to_remove)
        for file in $FILES
        do
            rm -rf data/$file
        done
        rm -rf to_remove
        find ./data/ -empty -type d -delete

        cp -R ./data/ $DATADIR/
        cp whosonfirst-data-$target-latest.csv $METADIR/whosonfirst-data-$target-latest.csv

        popd > /dev/null

        rm -rf whosonfirst-data-$target-latest
    fi
done

empty_admins=( continent localadmin borough county dependency disputed macrocounty macroregion )

for target in "${empty_admins[@]}"
do
    cp ../empty.csv whosonfirst-data-$target-latest.csv
done

cd ../
