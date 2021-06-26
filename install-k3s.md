# Installing k3s on Pis 


## Main node 

Install with: 

```
curl -sfL https://get.k3s.io | sudo INSTALL_K3S_EXEC="--docker" sh -
```

Get node token at
```
sudo cat /var/lib/rancher/k3s/server/node-token
```

## Worker nodes

Install with:
```
curl -sfL https://get.k3s.io | sudo K3S_URL=https://pi03.lan.chandl.io:6443 K3S_TOKEN='TOKEN-FROM-MAIN-NODE' INSTALL_K3S_EXEC="--docker" sh -
```