#!/bin/bash

sudo apt-get update -y
sudo apt-get upgrade -y

echo "=== Removing potential already installed Gitlab versions ==="
sudo apt-get remove gitlab -y

echo "=== Removing potential already installed docker versions (like in official doc advices) ==="
sudo apt-get remove docker docker-engine docker.io containerd runc -y

echo "=== Installing useful tools ==="
sudo apt-get install curl net-tools git vim openssh-server -y

echo "=== Installing Docker ==="
curl -fsSL https://get.docker.com -o get-docker.sh
sh ./get-docker.sh

echo "=== Installing and starting Gitlab in namespace gitlab ==="
sudo docker run --detach \
    --hostname gitlab.local \
    --publish 443:443 --publish 80:80 --publish 22:22 \
    --name gitlab \
    --restart always \
    --volume /srv/gitlab/config:/etc/gitlab \
    --volume /srv/gitlab/logs:/var/log/gitlab \
    --volume /srv/gitlab/data:/var/opt/gitlab \
    --network host \
    gitlab/gitlab-ce:latest

echo "=== Waiting for Gitlab to start ==="
sleep 60

echo "=== Creating local repository ==="
# Replace YOUR_USERNAME and YOUR_PRIVATE_TOKEN with your own Gitlab credentials
curl --request POST --header "PRIVATE-TOKEN: YOUR_PRIVATE_TOKEN" --data "name=my_local_repo&visibility=private" http://gitlab.local/api/v4/projects

echo "=== Installing Kubectl ==="
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

echo "=== Installing K3D ==="
sudo curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

echo "=== Creating K3D cluster ==="
sudo k3d cluster create mycluster -p 8080:80@loadbalancer --agents 2 --k3s-arg "--disable=traefik@server:0"

echo "=== Creating namespaces (argocd & dev & gitlab) ==="
sudo kubectl create namespace argocd
sudo kubectl create namespace dev
sudo kubectl create namespace gitlab

echo "=== Installing ArgoCD ==="
sudo kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

sleep 30

echo "=== Configuring access to ArgoCD server ==="
sudo kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'

sudo sleep 10

echo "USERNAME: admin (default)"
echo "PASSWORD: $(sudo kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d;)"

echo "=== Deploying manifest ==="
# Replace YOUR_GITLAB_IP with the IP address of the machine where you installed Gitlab
sed -i 's|https://github.com/elgrusko/cicd.git%7Chttp://YOUR_GITLAB_IP/YOUR_USERNAME/my_local_repo.git%7Cg' manifest.yaml
sudo kubectl apply -f manifest.yaml -n argocd
sudo sleep 60
sudo sh ./forward.sh