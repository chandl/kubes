#!/usr/bin/env bash 

NAMESPACE=nextcloud

echo "Creating namespace $NAMESPACE"
sudo k3s kubectl create namespace $NAMESPACE

echo "Creating nextcloud certs"
sudo ./update-nextcloud-certs.sh 

echo "Creating nextcloud"
sudo k3s kubectl apply -f nextcloud.yml -n $NAMESPACE

echo "Nextcloud created"
sudo k3s kubectl get svc -n nextcloud
sudo k3s kubectl get pods -n nextcloud

echo "Setting volume to retain data after deletes"
sudo k3s kubectl patch pv $(sudo k3s kubectl get pv | grep nextcloud | awk -F " " '{print $1}') -p '{"spec":{"persistentVolumeReclaimPolicy":"Retain"}}' -n $NAMESPACE