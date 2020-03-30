#!/bin/bash

# main Docker script has already created these:
export TOOLS=/mnt/tools
export DATA=/mnt/data
SCRIPTS=$TOOLS/scripts

#=========================================
# Install importers and their dependencies
#=========================================

# note: we cannot run parallel npm installs!

# param1: organization name
# param2: git project name
# param3: optional git commit id
# note: changes cd to new project dir
function install_node_project {
    git clone --single-branch https://github.com/$1/$2 $TOOLS/$2
    cd $TOOLS/$2
    if [ -n "$3" ]; then
        git checkout $3
    fi
    npm install

    #make the package locally available
    npm link
}

set -x
set -e
apt-get update
echo 'APT::Acquire::Retries "20";' >> /etc/apt/apt.conf
apt-get install -y --no-install-recommends git unzip python python-pip python-dev build-essential gdal-bin rlwrap procps emacs curl
rm -rf /var/lib/apt/lists/*

mkdir -p $SCRIPTS

curl -sL https://deb.nodesource.com/setup_10.x | bash -
apt-get install -y --no-install-recommends nodejs

cd $SCRIPTS

#install npm packaged deps
npm install

#install source repo deps
install_node_project opentransportro dbclient

install_node_project opentransportro pelias-schema

install_node_project opentransportro wof-admin-lookup

install_node_project opentransportro openstreetmap
npm link pelias-dbclient
npm link pelias-wof-admin-lookup

install_node_project opentransportro pelias-gtfs
npm link pelias-dbclient
npm link pelias-wof-admin-lookup
