# Run Httpd Container in Docker
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

  #
