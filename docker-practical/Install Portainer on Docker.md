# Run Portainer Container on Docker

Create the volume to store database:
####
    docker volume create portainer_data

Run Portainer Server container:

    docker run -d -p 8000:8000 -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest

Logging In:

    https://Dockerhost:9443
