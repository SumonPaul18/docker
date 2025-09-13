# Install Wordpress On Docker

Reference:
1. https://www.linkedin.com/pulse/how-install-wordpress-docker-using-compose-deepesh-waiba/
2. https://www.youtube.com/watch?v=pT08xKClJP0

Verify docker compose version

    docker compose version

Create a new project directory:
    
    mkdir wordpress

Navigate to the new directory:
    
    cd wordpress

Create a yaml file.

    nano docker-compose.yml

Create a new docker-compose.yml file, and paste the contents below:
####
    # Defines which compose version to use
    version: "20" 
    
    # Services line define which Docker images to run. In this case, it will be MySQL server and WordPress image.
    services:
      
      #db is a service name.
      db:
        # image: here you define your image with tag.  
        image: mysql:5.7
        restart: always
        environment:
          MYSQL_ROOT_PASSWORD: centos@123
          MYSQL_DATABASE: wordpress
          MYSQL_USER: sysadmin
          MYSQL_PASSWORD: centos@123
          # Previous four lines define the main variables needed for the MySQL container to work: database, database username, database user password, and the MySQL root password.
      wordpress:
        depends_on:
          - db
        image: wordpress:latest
        restart: always
        # Restart line controls the restart mode, meaning if the container stops running for any reason, it will restart the process immediately.
        ports:
          - "8000:80"
          # The previous line defines the port that the WordPress container will use. After successful installation, the full path will look like this: http://localhost:8000
        environment:
          WORDPRESS_DB_HOST: db:3306
          WORDPRESS_DB_USER: sysadmin
          WORDPRESS_DB_PASSWORD: centos@123
          WORDPRESS_DB_NAME: wordpress
    # Similar to MySQL image variables, the last four lines define the main variables needed for the WordPress container to work properly with the MySQL container.
        volumes:
          ["./:/var/www/html"]
    volumes:
      mysql: {}
  
Docker Compose UP

    docker compose up -d

Check Docker Compose
    
    docker compose ps

Open Browser

    http://dockerhost:8000

1st time setup the wordpress site:

> Site Title:
> User:
> Pass:
> Email:

Now Enjoying! Your Wordpress Site.

Check docker compose

    docker compose ps

Check docker PS
    
    docker ps

Down docker compose

    docker compose down

Setting up Wordpress with phpMyAdmin
####
    version: "3"
    services:
      db:
        image: mysql:5.7
        volumes:
          - mysql_data:/var/lib/mysql
        restart: always
        environment:
          MYSQL_ROOT_PASSWORD: centos@123
          MYSQL_DATABASE: wordpress
          MYSQL_USER: sysadmin
          MYSQL_PASSWORD: centos@123
        volumes:
          -  ./mysql:/var/lib/mysql
          
      phpmyadmin:
        image: phpmyadmin/phpmyadmin:latest
        depends_on:
          - db
        restart: always
        environment:
          PMA_HOST: db
          PMA_USER: sysadmin
          PMA_PASSWORD: centos@123
        ports:
          - "8080:80"
          
       wordpress:
        depends_on:
          - db
        image: wordpress:latest
        restart: always
        ports:
          - "8000:80"
        environment:
          WORDPRESS_DB_HOST: db:3306
          WORDPRESS_DB_USER: sysadmin
          WORDPRESS_DB_PASSWORD: centos@123
          WORDPRESS_DB_NAME: wordpress
          
        volumes:
          ["./wordpress:/var/www/html"]
    volumes:
      mysql_data:
  
  
Docker Compose UP

    docker compose up -d  
  

Access phpMyAdmin interface:

    http://localhost:8080/

Access wordpress interface:

    192.168.0.107:8000

#
