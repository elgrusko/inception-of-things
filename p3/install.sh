# Documentation : 
#  https://docs.docker.com/engine/install/ubuntu/
#  https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/
#  https://k3d.io/v5.4.2/#requirements
#  https://yashguptaa.medium.com/application-deploy-to-kubernetes-with-argo-cd-and-k3d-8e29cf4f83ee

sudo apt-get update -y
sudo apt-get ugrade -y

echo "===Removing potential already installed docker versions (like in official doc advices) ==="
sudo apt-get remove docker docker-engine docker.io containerd runc -y

echo "=== Install useful tools ==="
sudo apt-get install curl net-tools git vim openssh-server -y

echo "=== Install Docker ==="
curl -fsSL https://get.docker.com -o get-docker.sh
sh ./get-docker.sh

echo "=== Install Kubectl ==="
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

echo "=== Install K3D ==="
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

echo "=== Create K3D cluster==="
k3d cluster create mycluster

echo "=== Create namespaces (argocd & dev)==="
kubectl create namespace argocd
kubectl create namespace dev

echo "=== Install ArgoCD ==="
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

