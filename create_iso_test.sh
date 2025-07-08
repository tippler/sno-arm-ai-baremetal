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
    openshift-install-fips --dir generated/install-${1} create single-node-ignition-config
    podman run --pull=always --privileged --rm \
        -v /dev:/dev -v /run/udev:/run/udev -v .:/data -w /data \
        quay.io/coreos/coreos-installer:release \
        iso customize -f --network-nmstate network_config.yaml --dest-ignition generated/install-${1}/bootstrap-in-place-for-live-iso.ign --dest-device /dev/disk/by-path/pci-0008:06:00.0-nvme-1 rhcos-live.iso
fi
