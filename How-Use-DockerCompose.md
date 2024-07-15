### Use Use Docker Compose


####
Refference:
    - https://docs.docker.com/get-started/08_using_compose/

show docker compose list
    docker compose ps

up docker compose
    docker-compose up -d

down docker compose

    docker-compose down

docker compose up with a non-default yml file name

    docker-compose -f docker-compose.prod.yml up -d

docker compose down with a non-default yml file name

    docker-compose -f docker-compose-test.yml down

How to add hosts in /etc/hosts files
    extra_hosts:
   - "somehost:162.242.195.82"
   - "otherhost:50.31.209.229"
