#!/bin/bash

if [ -z "$1" ]
  then
    echo "No argument supplied \ln"
    echo "Enter the cluster id as in the config-files folder \ln"
    echo "        ./create-iso.sh [CLUSTERID]    \ln"
  else
    #export XDG_CONFIG_HOME=$(pwd)/..
    #export HOME=$(pwd)/..
    export ARCH="aarch64"
    rm -rf generated/install-${1} || true
    rm -rf rhcos-live.iso
    cp ../rhcos-generic-arm.iso ./rhcos-live.iso
    mkdir -p generated/install-${1}
    cp -r ../config-files/${1}/* generated/install-${1}
    openshift-install --dir generated/install-${1} create single-node-ignition-config
    podman run --privileged --pull always --rm \
        -v /dev:/dev -v /run/udev:/run/udev -v $PWD:/data \
        -w /data quay.io/coreos/coreos-installer:release \
        iso ignition embed -fi generated/install-${1}/bootstrap-in-place-for-live-iso.ign rhcos-live.iso
fi
