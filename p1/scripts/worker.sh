#!/bin/bash

echo "install k3s [agent]"
echo $2 # == SW_IP
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="agent --server https://$1:6443 --node-ip $3 --token-file $2" sh -s -
echo "k3s installed [agent]"

# Export PATH and alias to use commands like in the subject
echo 'alias k="kubectl"' >> ~/.bashrc
echo 'export PATH="/usr/sbin/:$PATH"' >> ~/.bashrc