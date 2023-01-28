# IoT - P4

## Requirements

- Vagrant 2.0 or later
- VirtualBox (or other supported Vagrant providers)

## Installation

- Install Vagrant by following the instructions on the official website.
- Install VirtualBox by following the instructions on the official website.
- Clone this repository or download the `Vagrantfile`, `install.sh`, and `gitlab.yaml` files.
- In the command line, navigate to the directory where the files are located and `run vagrant up`. This will download the specified box (centos/stream8) and configure the virtual machine according to the settings specified in the Vagrantfile.
- The script install.sh will run automatically to install and configure GitLab on the virtual machine.
- After the installation is complete, you can access GitLab by going to http://192.168.56.142:8181 in your web browser. The initial root password for GitLab can be found by running `sudo cat /etc/gitlab/initial_root_password` on the virtual machine.
- To deploy the application in Kubernetes, you should run the script with the path to the configuration files.
- The `gitlab.yaml` file should be used to apply the configuration in the ArgoCD, it is important to note that the server URL and the URL of the repository should be correctly configured.

## Deployment

Run `vagrant up` to start the virtual machine and deploy GitLab.
Run the script with the path to the configuration files, it will create and apply the configurations in the ArgoCD.

## Utilities

Vagrant is used to create and manage the virtual machine.
VirtualBox is used as the provider for the virtual machine.
GitLab CE package is installed on the virtual machine for GitLab functionality.
The install.sh script is used to install and configure GitLab on the virtual machine.
The gitlab.yaml is used to apply the configuration in the ArgoCD.

## Note

This project uses the centos/stream8 box and may not work with other boxes or providers.
Be sure to check the versions of the packages used in this project before running the script, if there are any issues, please update the packages to the latest version.
This project is intended for testing and development purposes only and may not be suitable for production use.
