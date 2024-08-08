#!/bin/bash

# Update system packages
sudo apt update

# Setup firewall rules
sudo ufw allow 8080/tcp
sudo ufw allow 9001/tcp
sudo ufw allow 10001/tcp
sudo ufw enable
sudo ufw status

# Install curl
sudo apt-get install -y curl

# Update package manager
sudo apt update

# Install Docker
sudo apt install -y docker.io
if ! docker --version &> /dev/null
then
    echo "Docker installation failed."
    exit 1
fi

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
if ! docker-compose --version &> /dev/null
then
    echo "Docker Compose installation failed."
    exit 1
fi

# Check if required ports are free
for port in 8080 9001 10001
do
    if lsof -i:$port &> /dev/null
    then
        echo "Port $port is already in use. Please free the port or change the configuration."
        exit 1
    fi
done

# Download and install Shardeum Validator
curl -O https://raw.githubusercontent.com/shardeum/validator-dashboard/main/installer.sh
chmod +x installer.sh
./installer.sh

# Navigate to the Shardeum directory and start the shell and GUI
cd ~/.shardeum
./shell.sh

# Start the Shardeum GUI using operator-cli
operator-cli gui start

# The script will prompt you to set up the validator. Please follow the on-screen instructions.
