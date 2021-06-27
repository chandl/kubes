# Nextcloud Kubernetes

This will install a barebones nextcloud installation on a kubernetes cluster. 
The hostname will be nextcloud.lan.chandl.io 
Creates a 2TB mount in /hdd on pi02 (external hdd) and sets up nextcloud to use this.

## Install:

```
sudo ./create-nextcloud.sh
``` 

## Uninstall:

```
sudo k3s kubectl delete namespace nextcloud
```
