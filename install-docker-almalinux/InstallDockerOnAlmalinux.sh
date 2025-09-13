#!/bin/bash
#Installing Docker on AlmaLinux 9

#Update Your System
sudo dnf update -y

#Set up the repository
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

#Install Docker Engine
sudo yum install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

#Start Docker
sudo systemctl start docker

#Enable Docker
sudo systemctl enable docker

#Check Docker Version
docker --version

#Manage Docker as a non-root user
sudo usermod -aG docker $USER

#Verify Docker service is running
#sudo systemctl status docker
