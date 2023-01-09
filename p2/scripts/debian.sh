sudo iptables -F
sudo update-alternatives --set iptables /usr/sbin/iptables-legacy
sudo update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy

# Export PATH and alias to use commands like in the subject
echo 'alias k="kubectl"' >> /etc/profile
echo 'export PATH="/usr/sbin/:$PATH"' >> /etc/profile
