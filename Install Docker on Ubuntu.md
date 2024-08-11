# Install Docker Engine on Ubuntu


Install using the Apt repository

Add Docker's official GPG key:
####
    sudo apt-get update -y
    sudo apt-get install ca-certificates curl gnupg -y
    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    sudo chmod a+r /etc/apt/keyrings/docker.gpg

Add the repository to Apt sources:
####
    echo \
      "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
      "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
####
    sudo apt-get update

Install the Docker packages:

    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

Verify the Docker Version:

    docker --version

Verify that the Docker Engine installation is successful by running the hello-world image.

    sudo docker run hello-world

Checking Running Containers

    docker ps

Manage Docker as a non-root user

To create the docker group and add your user:

Create the docker group.

    sudo groupadd docker

Add your user to the docker group.

    sudo usermod -aG docker $USER

Configure Docker to start on boot with systemd

    sudo systemctl enable docker.service
    sudo systemctl enable containerd.service

To stop this behavior, use disable instead.

    sudo systemctl disable docker.service
    sudo systemctl disable containerd.service

Uninstall Docker Engine:

    sudo apt-get purge docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-ce-rootless-extras

Images, containers, volumes, or custom configuration files on your host aren't automatically removed. To delete all images, containers, and volumes:

    sudo rm -rf /var/lib/docker
    sudo rm -rf /var/lib/containerd

#



