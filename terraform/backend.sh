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
else
    echo "Unsupported package manager. Exiting."
    exit 1
fi


git clone https://github.com/nadine2000/pokemon3

cd pokemon3/backend

sudo docker-compose up --build
