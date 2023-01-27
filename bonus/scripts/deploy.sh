echo "=== Cleaning namespaces ==="
kubectl delete namespace gitlab

echo "=== Creating namespaces ==="
kubectl create namespace gitlab

echo "=== Applying applications ==="
kubectl apply -n argocd -f ../confs/gitlab.yaml
kubectl apply -n argocd -f ../confs/projects.yaml
