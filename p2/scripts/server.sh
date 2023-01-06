#!/bin/bash

echo "install k3s [server]"
echo $1 # == S_IP
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--bind-address=$1 --node-ip=$1 --write-kubeconfig-mode=644" sh -s -
echo "k3s installed [server]"

kubectl apply -f /vagrant/app1/app1.yaml
kubectl apply -f /vagrant/app1/app1_service.yaml
echo "app1 is running"

kubectl apply -f /vagrant/app2/app2.yaml
kubectl apply -f /vagrant/app2/app2_service.yaml
echo "app2 is running"

kubectl apply -f /vagrant/app3/app3.yaml
kubectl apply -f /vagrant/app3/app3_service.yaml
echo "app3 is running"

kubectl apply -f /vagrant/ingress.yaml
echo "ingress is running (it may takes one or two minutes to be accessible, in that case, just wait)"