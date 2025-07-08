if [ -z "$1" ]
  then
    echo "No argument supplied \ln"
    echo "Enter the cluster id as in the config-files folder \ln"
    echo "        ./create-iso.sh [CLUSTERID]    \ln"
  else
    rm -rf generated/install-${1} || true
    mkdir -p generated/install-${1}
    cp -r ../config-files/${1}/* generated/install-${1}
    openshift-install agent create image --dir generated/install-${1}
fi

