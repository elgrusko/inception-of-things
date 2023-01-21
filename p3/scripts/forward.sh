# if a processes is already listening on port 8888, then we kill them
sudo fuser -k 8888/tcp

while true; do sudo kubectl port-forward svc/wil-playground -n dev 8888:8888 2>&1 > /dev/null; done
