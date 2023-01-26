# Configure the system locale to UTF-8
sudo localedef -v -c -i en_US -f UTF-8 en_US.UTF-8

# Disable and stop the firewalld service
systemctl disable firewalld --now

# Install the GitLab CE package repository
curl -s https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.rpm.sh | sudo bash

# Install the GitLab CE package
yum -y install gitlab-ce

# Update the external URL in the GitLab configuration file to use the IP address and port of the VM
sudo sed -i 's|external_url \x27http://gitlab.example.com\x27|external_url \x27http://192.168.56.142:8181\x27|g' /etc/gitlab/gitlab.rb 

# Reconfigure GitLab
sudo gitlab-ctl reconfigure

# Print the initial root password for GitLab
sudo cat /etc/gitlab/initial_root_password
