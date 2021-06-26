#!/usr/bin/env bash 

# Creates a kubernetes-dashboard instance behind traefik 
# https://blog.heptio.com/on-securing-the-kubernetes-dashboard-16b09b1b7aca

### Uncomment the below to download new versions 
# GITHUB_URL=https://github.com/kubernetes/dashboard/releases
# VERSION_KUBE_DASHBOARD=$(curl -w '%{url_effective}' -I -L -s -S ${GITHUB_URL}/latest -o /dev/null | sed -e 's|.*/||')
# echo "Downloading kubernetes-dashboard $VERSION_KUBE_DASHBOARD"
# wget https://raw.githubusercontent.com/kubernetes/dashboard/${VERSION_KUBE_DASHBOARD}/aio/deploy/recommended.yaml -O dashboard.yml

NAMESPACE="kubernetes-dashboard"


echo "Creating namespace $NAMESPACE"
sudo k3s kubectl create namespace $NAMESPACE

echo "Creating certificates"
sudo ./update-dashboard-certs.sh

echo "Installing kubernetes-dashboard $VERSION_KUBE_DASHBOARD"
sudo k3s kubectl create -f dashboard.yml

echo "Creating admin user and role"
sudo k3s kubectl create -f admin-user.yml -f admin-user-role.yml

echo "Creating traefik ingress rule"
sudo k3s kubectl -n $NAMESPACE apply -f ingress.yml 

echo "Obtaining login token"
sudo k3s kubectl -n $NAMESPACE describe secret admin-user-token | grep '^token'

echo "CREATED... Services:"
sudo k3s kubectl -n $NAMESPACE get svc

echo "Pods:"
sudo k3s kubectl -n $NAMESPACE get pods