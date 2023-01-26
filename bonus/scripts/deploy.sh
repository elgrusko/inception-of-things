path_conf=/home/sasso/Documents/GitHub/inception-of-things/bonus/confs

echo "=== Cleaning namespaces ==="
kubectl delete namespace gitlab

echo "=== Creating namespaces ==="
kubectl create namespace gitlab

echo "=== Applying applications ==="
kubectl apply -n argocd -f $path_conf/gitlab.yaml
kubectl apply -n argocd -f $path_conf/projects.yaml
