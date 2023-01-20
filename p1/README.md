# IoT - P1

This configuration file uses Vagrant and VirtualBox to set up two virtual machines: a server and a worker.

## Prerequisites

- Vagrant
- VirtualBox

## Configuration

The following variables can be adjusted to configure the virtual machines:

- `MEMORY`: The amount of memory to allocate to each virtual machine (in MB).
- `CPU`: The number of CPUs to allocate to each virtual machine.
- `S_NAME`: The hostname of the server virtual machine.
- `S_IP`: The private IP address of the server virtual machine.
- `SW_NAME`: The hostname of the worker virtual machine.
- `SW_IP`: The private IP address of the worker virtual machine.
- `TOKEN_FILE`: The path to a file containing a token.

## Usage

1. Install Vagrant and VirtualBox.
2. Download this configuration file and place it in an empty directory.
3. From the command line, navigate to the directory containing the configuration file.
4. Run `vagrant up` to create and configure the virtual machines.

## Virtual Machines

### Server

- Hostname: `S_NAME` (default: `elgruskoS`)
- IP address: `S_IP` (default: `192.168.56.110`)
- Operating system: Debian 10
- Provisioning script: `./scripts/server.sh` (run with argument `S_IP`)

The `./scripts/server.sh` script is used to install and set up a Kubernetes server using k3s. It takes a single argument, which is the IP address of the server virtual machine. It uses curl to download the k3s installation script and runs it with the `INSTALL_K3S_EXEC` flag to specify that the script should install and configure a Kubernetes server. It then writes the Kubernetes server token to the file specified by `TOKEN_FILE`.

### Worker

- Hostname: `SW_NAME` (default: `elgruskoSW`)
- IP address: `SW_IP` (default: `192.168.56.111`)
- Operating system: Debian 10
- Provisioning script: `./scripts/worker.sh` (run with arguments `S_IP`, `TOKEN_FILE`, and `SW_IP`)

The `./scripts/worker.sh` script is used to install and set up a Kubernetes worker node using k3s. It takes three arguments: the IP address of the server virtual machine, the path to the file containing the server token, and the IP address of the worker virtual machine. It uses curl to download the k3s installation script and runs it with the `INSTALL_K3S_EXEC` flag to specify that the script should install and configure a Kubernetes worker node, connecting it to the specified server.

## Provisioning Script

The configuration file also specifies the `./scripts/debian.sh` script to run during the provisioning process. This script configures some networking settings on the virtual machines, using `iptables` to flush the current rules and then setting the `iptables` and `ip6tables` alternatives to use the legacy versions of the tools.
