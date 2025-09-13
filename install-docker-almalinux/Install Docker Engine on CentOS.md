
# How to Install Docker on CentOS

Set up the repository:

    sudo yum install -y yum-utils
    sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

Install Docker Engine

Install Docker Engine, containerd, and Docker Compose:

    sudo yum install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

Start Docker:

    sudo systemctl start docker

Verify the Docker Version

    docker --version

Verify that the Docker Engine installation is successful by running the hello-world image.
    
    sudo docker run hello-world

Uninstall Docker Engine:

    sudo yum remove docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-ce-rootless-extras

Images, containers, volumes, or custom configuration files on your host aren't automatically removed. To delete all images, containers, and volumes:

    sudo rm -rf /var/lib/docker
    sudo rm -rf /var/lib/containerd

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

#
