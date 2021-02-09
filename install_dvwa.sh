#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

echo 127.0.0.1 $(hostname) | sudo tee -a /etc/hosts

# Install Docker
if [ ! $(which docker) ]; then
    echo "----Installing docker----"
    apt update > /dev/null
    apt install -y apt-transport-https ca-certificates curl software-properties-common > /dev/null
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    apt update > /dev/null
    apt install -y docker-ce > /dev/null
fi

# Run the Docker container
docker run --name dvwa -d -p 80:80 vulnerables/web-dvwa
