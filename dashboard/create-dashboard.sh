#!/usr/bin/env bash 
GITHUB_URL=https://github.com/kubernetes/dashboard/releases
VERSION_KUBE_DASHBOARD=$(curl -w '%{url_effective}' -I -L -s -S ${GITHUB_URL}/latest -o /dev/null | sed -e 's|.*/||')


echo "Downloading kubernetes-dashboard $VERSION_KUBE_DASHBOARD"
wget https://raw.githubusercontent.com/kubernetes/dashboard/${VERSION_KUBE_DASHBOARD}/aio/deploy/recommended.yaml -O dashboard.yml

echo "Installing kubernetes-dashboard $VERSION_KUBE_DASHBOARD"
sudo k3s kubectl create -f dashboard.yml

echo "Creating admin user and role"
sudo k3s kubectl create -f dashboard.admin-user.yml -f dashboard.admin-user-role.yml

echo "Obtaining login token"
sudo k3s kubectl -n kubernetes-dashboard describe secret admin-user-token | grep '^token'
