#!/usr/bin/env bash

NAMESPACE="timetrack"

echo "Creating namespace $NAMESPACE"
sudo k3s kubectl create namespace $NAMESPACE

echo "Creating timetrack certs"
sudo ./update-timetrack-certs.sh

echo "Creating timetrack configmap"
sudo k3s kubectl apply -f timetrack-config.yml -n $NAMESPACE

echo "Generating MariaDB Root Password"
TMP_PW=$(sudo mktemp)
tr -dc 'A-Za-z0-9_#$!@\-' </dev/urandom | head -c 20 | sudo tee -a $TMP_PW
sudo k3s kubectl create secret generic mysql-root-password -n $NAMESPACE --from-file=password=$TMP_PW
sudo rm $TMP_PW
sudo k3s kubectl describe secrets/mysql-root-password -n $NAMESPACE

echo "Generating MariaDB Timetrack Password"
TMP_PW=$(sudo mktemp)
tr -dc 'A-Za-z0-9_#$!@\-' </dev/urandom | head -c 20 | sudo tee -a $TMP_PW
sudo k3s kubectl create secret generic mysql-timetrack-password -n $NAMESPACE --from-file=password=$TMP_PW
sudo rm $TMP_PW
sudo k3s kubectl describe secrets/mysql-timetrack-password -n $NAMESPACE

echo "Deploying MariaDB"
sudo k3s kubectl apply -f mariadb.yml -n $NAMESPACE

echo "Deploying Timetrack Service"
sudo k3s kubectl apply -f timetrack.yml -n $NAMESPACE

echo "Services Deployed!"
sudo k3s kubectl get pods -n $NAMESPACE