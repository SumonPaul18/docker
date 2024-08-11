# Integration Traefik with httpd Container
Create a Directory and Docker Compose file

    mkdir httpd-traefik && cd httpd-traefik
    nano docker-compose.yml
####
    version: '3.3'
    services:
      apache:
        image: httpd:latest
        container_name: myapache
        ports:
        - '8082:80'
        volumes:
        - ./website:/usr/local/apache2/htdocs
        restart: unless-stopped
        #depends_on:
        #- traefik
        labels:
        - "traefik.http.routers.myapache.rule=Host(`myapache.paulco.local`)"

#
