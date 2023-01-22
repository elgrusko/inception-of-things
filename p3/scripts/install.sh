# Documentation : 
#  https://docs.docker.com/engine/install/ubuntu/
#  https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/
#  https://k3d.io/v5.4.2/#requirements
#  https://yashguptaa.medium.com/application-deploy-to-kubernetes-with-argo-cd-and-k3d-8e29cf4f83ee

sudo apt-get update -y
sudo apt-get upgrade -y

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
sudo curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

echo "=== Create K3D cluster==="
sudo k3d cluster create mycluster -p 8080:80@loadbalancer --agents 2 --k3s-arg "--disable=traefik@server:0"

echo "=== Create namespaces (argocd & dev)==="
sudo kubectl create namespace argocd
sudo kubectl create namespace dev

echo "=== Install ArgoCD ==="
sudo kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

sleep 30

#better way but i didnt succeed : https://enix.io/fr/blog/kubernetes-tip-and-tricks-la-commande-wait/
#sudo kubectl wait --for=condition=ready deployments -n argocd
#sudo kubectl wait --for=condition=ready pods -n argocd

echo "=== Config Access to Argo CD Server ==="
sudo kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'

sudo sleep 10

echo "USERNAME: admin (default)"
echo "PASSWORD: $(sudo kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d;)"

echo "=== Deploy manifest ==="
sudo kubectl apply -f manifest.yaml -n argocd
sudo sleep 60
sudo sh ./forward.sh
