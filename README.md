docker-ucarp
============

[![Docker Image CI](https://github.com/kwiksand/docker_ucarp/actions/workflows/main.yml/badge.svg?branch=main)](https://github.com/kwiksand/docker_ucarp/actions/workflows/main.yml)

Builds a basic ucarp enabled container, which creates a virtual (VRRP) IP (UCARP_VIP_ADDRESS) on the host interface (UCARP_HOST_DEVICE) using ucarp.


usage
-----
Build:
```
$ docker build .
```

Docker Compose (docker-compose.yaml):
```bash
---
services:

  # Runs using the same config, but another container using hosts IP
  ucarp:
    container_name: dns-server_ucarp
    image: ghcr.io/kwiksand/docker_ucarp 
    #privileged: true
    security_opt:
      - seccomp:unconfined
    network_mode: host
    environment:
      UCARP_HOST_DEVICE: ens3 # The hosts primary device
      UCARP_HOST_ADDRESS: '192.168.0.26' # The IP Address of the host device
      UCARP_VIP_ADDRESS: '192.168.0.241' # The requested VIP
      UCARP_PASSWORD:  'XXXXXXXX'
      UCARP_VID: '018' # The Virtual Interface ID (used for specifiying ucarp installations with multiple containers)
      UCARP_PRIORITY: 3 # The host priority (lowest number becomes the master)
    cap_add:
      - NET_ADMIN
    restart: always
    labels:
      - "com.centurylinklabs.watchtower.enable=false"
    healthcheck:
      test: ["CMD", "pgrep", "/usr/sbin/ucarp"]
      interval: 30s
      timeout: 10s
      retries: 3

```

Run in Docker:
```
$ docker run -e UCARP_VID=$UCARP_VID -e UCARP_HOST_ADDRESS=$UCARP_HOST_ADDRESS -e UCARP_VIP_ADDRESS=$UCARP_VIP_ADDRESS -e UCARP_PASSWORD=$UCARP_PASSWORD -e UCARP_DEVICE=$UCARP_DEVICE --privileged=true --net=host ctracey/ucarp

```

Run in Kubernetes:
```
---
apiVersion: v1
kind: Pod
metadata:
  name: kube-ucarp-vip
  namespace: kube-system
spec:
  hostNetwork: true
  containers:
  - name: kube-ucarp-vip
    image: ghcr.io/docker_ucarp
    securityContext:
      privileged: true
    env:
    - name: UCARP_VID
      value: "41"
    - name: UCARP_HOST_DEVICE
      value: "eth0"
    - name: UCARP_VIP_ADDRESS
      value: "1.1.1.1/24"
    - name: UCARP_PASSWORD
      value: "somepassword"
```
