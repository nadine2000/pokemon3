#!/bin/bash

install_docker_compose() {
    echo "Installing Docker Compose..."
    DOCKER_COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep tag_name | cut -d '"' -f 4)
    sudo curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-linux-x86_64" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    echo "Docker Compose installed: $(docker-compose --version)"
}

# Amazon Linux
if command -v yum &> /dev/null; then
    echo "Detected yum-based system. Installing Git, Docker, and Docker Compose..."
    sudo yum update -y
    sudo yum install -y git docker
    sudo service docker start
    sudo usermod -aG docker $USER

    install_docker_compose


# Ubuntu
elif command -v apt &> /dev/null; then
    echo "Detected apt-based system. Installing Git, Docker, and Docker Compose..."

    # Update package info and install dependencies
    sudo apt update -y
    sudo apt install -y \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg \
        lsb-release \
        git

    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

    # Install Docker Engine
    sudo apt update -y
    sudo apt install -y docker-ce docker-ce-cli containerd.io

    # Start Docker and add user to docker group
    sudo systemctl start docker
    sudo systemctl enable docker
    sudo usermod -aG docker $USER

    install_docker_compose
else
    echo "Unsupported package manager. Exiting."
    exit 1
fi


git clone https://github.com/nadine2000/pokemon3

cd pokemon3/backend

sudo docker-compose up --build
