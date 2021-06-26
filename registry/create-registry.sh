#!/usr/bin/env bash 
# Creates docker registry 
#   registry.lan.chandl.io 
#   http and https using letsencrypt certs

REGISTRY_YML_FILE="./docker-registry.yml"
NAMESPACE="docker-registry"


echo "Creating namespace $NAMESPACE"
sudo k3s kubectl create namespace $NAMESPACE

echo "Creating certificates"
./update-docker-registry-certs.sh

echo "Creating registry"
sudo k3s kubectl apply -f $REGISTRY_YML_FILE -n $NAMESPACE
