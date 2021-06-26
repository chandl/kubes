#!/usr/bin/env bash 

NAMESPACE=nextcloud

echo "Creating namespace $NAMESPACE"
sudo k3s kubectl create namespace $NAMESPACE

echo "Creating nextcloud certs"
sudo ./update-nextcloud-certs.sh 

echo "Creating nextcloud"
sudo k3s kubectl apply -f nextcloud.yml -n $NAMESPACE