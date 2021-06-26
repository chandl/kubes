# Timetrack Kubernetes

This will install timetrack from our local docker registry to the kubernetes cluster.
It will also install a MariaDB server backend. 
The hostname will be timetrack.lan.chandl.io 

## Install:

```
sudo ./create-timetrack.sh
``` 

## Uninstall:

```
sudo k3s kubectl delete namespace timetrack
```