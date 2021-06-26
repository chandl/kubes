#!/usr/bin/env bash 

TMP_CERT_FOLDER="$(mktemp -d)"

echo "Made temp directory $TMP_CERT_FOLDER"

sudo certbot renew
sudo cp /etc/letsencrypt/live/lan.chandl.io/fullchain.pem $TMP_CERT_FOLDER/tls.crt
sudo cp /etc/letsencrypt/live/lan.chandl.io/privkey.pem $TMP_CERT_FOLDER/tls.key

ls -ltrh $TMP_CERT_FOLDER

echo "Updating secret in k3s"
sudo k3s kubectl create secret generic timetrack-certs --from-file=$TMP_CERT_FOLDER -n timetrack --save-config --dry-run=client -o yaml  | kubectl apply -f -

echo "Updated secret"
sudo k3s kubectl describe secret timetrack-certs -n timetrack

echo "Removing temp directory $TMP_CERT_FOLDER"
sudo rm -rf $TMP_CERT_FOLDER
