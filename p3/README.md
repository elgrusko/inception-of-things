# IoT - P3

## Prerequisites

- Docker
- K3D

## Script

The install.sh script is a shell script that automates the process of setting up a minimalist version of K3S on a virtual machine. It does the following:

- Updates and upgrades the system
- Removes any existing Docker versions
- Installs necessary tools such as curl, net-tools, git, and vim
- Installs Docker
- Installs kubectl
- Installs K3D
- Creates a K3D cluster
- Creates namespaces for argocd and dev
- Installs ArgoCD
- Configures access to the ArgoCD server
- Prints the default ArgoCD username and password
- Deploys the manifest.yaml file

It is intended to be run on Ubuntu and similar distributions, and must be run with sudo privileges. Once the script has completed, you can access the application on port 8888 in the dev namespace, and use ArgoCD to manage it.

```sh
git clone https://github.com/elgrusko/cicd.git
cd cicd
sh install.sh
Script
#!/bin/bash

# Update and upgrade the system
sudo apt-get update -y
sudo apt-get ugrade -y

# Remove any existing Docker versions
sudo apt-get remove docker docker-engine docker.io containerd runc -y

# Install necessary tools
sudo apt-get install curl net-tools git vim openssh-server -y

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sh ./get-docker.sh

# Install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Install K3D
sudo curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

# Create K3D cluster
sudo k3d cluster create mycluster -p 8080:80@loadbalancer --agents 2 --k3s-arg "--disable=traefik@server:0"

# Create namespaces (argocd & dev)
sudo kubectl create namespace argocd
sudo kubectl create namespace dev

# Install ArgoCD
sudo kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Config Access to Argo CD Server
sudo kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'

# Print the default ArgoCD username and password
echo "USERNAME: admin (default)"
echo "PASSWORD: $(sudo kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d;)"

# Deploy manifest
sudo kubectl apply -f manifest.yaml -n argocd

```

## Manifest

This Kubernetes manifest defines an ArgoCD application named "wil42".
It specifies the following:

- The destination namespace for the application is "dev" and it will be deployed on the Kubernetes cluster's default server.
- The source of the application is the current directory (.) of the repository located at 'https://github.com/elgrusko/cicd.git' and it will always target the latest revision (HEAD)
- The project is set to default.
- The syncPolicy is set to automated with prune and self-heal set to true.

This manifest file is typically used in conjunction with ArgoCD to automate the deployment of the application on the specified Kubernetes cluster.

``` yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: wil42
spec:
  destination:
    name: ''
    namespace: dev
    server: 'https://kubernetes.default.svc'
  source:
    path: .
    repoURL: 'https://github.com/elgrusko/cicd.git'
    targetRevision: HEAD
  project: default
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
```

## Usage

Once the script has completed, you can access the application on port 8888 in the dev namespace. The version of the application can be changed by updating the appropriate tag in the Github repository and verifying that the update is reflected in the deployed application.

You can access the ArgoCD server by running

``` sh
kubectl get svc -n argocd
```

and accessing the EXTERNAL-IP. The default username and password are admin and the one printed at the end of the installation.
