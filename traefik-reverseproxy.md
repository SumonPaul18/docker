# Run Traefik Reverse Proxy with Docker Compose

Create a Directory and Docker Compose file
####
    mkdir traefik && cd traefik
    nano docker-compose.yml
####
    version: '3.3'
    services:
      traefik:
        image: traefik:latest
        container_name: traefik
        command: --api.insecure=true --providers.docker
        ports:
        - 81:80
        - 8080:8080
        volumes:
        - /var/run/docker.sock:/var/run/docker.sock

####
    docker compose up -d
####
    docker compose down
####
    docker compose ps
####
    docker ps
