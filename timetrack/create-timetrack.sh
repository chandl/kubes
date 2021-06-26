#!/usr/bin/env bash

NAMESPACE="timetrack"

echo "Creating namespace $NAMESPACE"
sudo k3s kubectl create namespace $NAMESPACE

# if ! command -v helm &> /dev/null
# then
#     echo "helm could not be found, installing..."
#     curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | sudo bash

#     echo "Exporting kube config"
#     sudo k3s kubectl config view --raw > ~/.kube/config

#     echo "Updating kube config permissions"
#     sudo chmod 600 ~/.kube/config

#     echo "Adding bitnami repo to helm"
#     sudo helm repo add bitnami https://charts.bitnami.com/bitnami

#     echo "Updating helm repos"
#     sudo helm repo update
# fi
# echo "Installing MariaDB"
# sudo helm install timetrack-db bitnami/mariadb -f mariadb.yml -n $NAMESPACE 

echo "Creating timetrack certs"
sudo ./update-timetrack-certs.sh

echo "Creating timetrack configmap"
sudo k3s kubectl apply -f timetrack-config.yml -n $NAMESPACE

head /dev/urandom | tr -dc A-Za-z0-9 | head -c 16 ; echo '' | base64 | kubectl create secret generic mysecret --from-literal=password=-

echo "Installing MariaDB"
sudo k3s kubectl apply -f mariadb.yml -n $NAMESPACE

echo "Generating MYSQL Root Password"
TMP_PW=$(sudo mktemp)
tr -dc 'A-Za-z0-9_#$!@\-' </dev/urandom | head -c 20 | sudo tee -a $TMP_PW
sudo k3s kubectl create secret generic mysql-root-password -n $NAMESPACE --from-file=password=$TMP_PW
sudo rm $TMP_PW
sudo k3s kubectl describe secrets/mysql-root-password -n timetrack

echo "Generating MYSQL Timetrack Password"
TMP_PW=$(sudo mktemp)
tr -dc 'A-Za-z0-9_#$!@\-' </dev/urandom | head -c 20 | sudo tee -a $TMP_PW
sudo k3s kubectl create secret generic mysql-timetrack-password -n $NAMESPACE --from-file=password=$TMP_PW
sudo rm $TMP_PW
sudo k3s kubectl describe secrets/mysql-timetrack-password -n timetrack


"""
ubuntu@pi03:~/kubes/timetrack$ helm install timetrack-db bitnami/mariadb -f mariadb.yml -n timetrack 
NAME: timetrack-db
LAST DEPLOYED: Sat Jun 26 17:52:06 2021
NAMESPACE: timetrack
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
Please be patient while the chart is being deployed

Tip:

  Watch the deployment status using the command: kubectl get pods -w --namespace timetrack -l app.kubernetes.io/instance=timetrack-db

Services:

  echo Primary: timetrack-db-mariadb.timetrack.svc.cluster.local:3306

Administrator credentials:

  Username: root
  Password : $(kubectl get secret --namespace timetrack timetrack-db-mariadb -o jsonpath="{.data.mariadb-root-password}" | base64 --decode)

To connect to your database:

  1. Run a pod that you can use as a client:

      kubectl run timetrack-db-mariadb-client --rm --tty -i --restart='Never' --image  docker.io/bitnami/mariadb:10.3.22-debian-10-r27 --namespace timetrack --command -- bash

  2. To connect to primary service (read/write):

      mysql -h timetrack-db-mariadb.timetrack.svc.cluster.local -uroot -p my_database

To upgrade this helm chart:

  1. Obtain the password as described on the 'Administrator credentials' section and set the 'auth.rootPassword' parameter as shown below:

      ROOT_PASSWORD=$(kubectl get secret --namespace timetrack timetrack-db-mariadb -o jsonpath="{.data.mariadb-root-password}" | base64 --decode)
      helm upgrade --namespace timetrack timetrack-db bitnami/mariadb --set auth.rootPassword=$ROOT_PASSWORD

"""