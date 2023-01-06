#!/bin/bash

echo "install k3s [server]"
echo $1 # == S_IP
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--bind-address=$1 --node-ip=$1 --write-kubeconfig-mode=644" sh -s -
cp /var/lib/rancher/k3s/server/token $2
echo "k3s installed [server]"