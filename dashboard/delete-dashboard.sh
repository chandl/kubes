#!/usr/bin/env bash 
NAMESPACE="kubernetes-dashboard"

echo "Removing namespace $NAMESPACE"
sudo k3s kubectl delete namespace $NAMESPACE
