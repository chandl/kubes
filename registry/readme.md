# Docker Registry Kubernetes

This will install a docker registry image to your kubernetes cluster. 
The hostname will be registry.lan.chandl.io 

## Install:

```
sudo ./create-registry.sh
``` 

## Uninstall:

```
sudo k3s kubectl delete namespace docker-registry
```
