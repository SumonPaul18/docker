#
## Working With Docker Containers
#
Get detailed information about docker:
####
    docker info
####
Docker version
####
    docker --version
Search for Docker Images:<br>
[ubuntu] is a image name, here as our needed image
####
    docker search ubuntu    
####
Pull a Docker Image: <br>
Download the official Ubuntu image by running
####
    docker pull ubuntu
####
View Downloaded Images:
####
    docker images
####
Run a Docker Container with non-interactive mode: <br>
[ubuntu] is our downloaded image. if haven't download previously, then would download image when run this command.
####
    docker run ubuntu    
####
Run a Docker Container with a container name and non-interactive mode <br>
docker run --name [container-name] [image-name]

    docker run --name myubuntu ubuntu

Run a Docker Container with interactive shell access

[ubuntu] is a image name and -it is interactive mode

    docker run -it ubuntu

NOTE:Back from Container Terminal to Host Terminal with stoping the Container

    exit

NOTE:Back from Container Terminal to Host Terminal without stoping the Container

    ctrl+p+q

Run Ubuntu Container with tag

[:latest is a images tag, we are run specefic images verify with tag

tag means: latest, version, or identified by a images. 

    docker run –it ubuntu:latest /bin/bash 

Container running in the background with bash shell.

Here -i for interactive mode, -t for terminal, -d for daemon mode, bash for bash shell mode

    docker run -it -d ubuntu bash

Enter a Container to Access Bash Shell in Terminal.

Here, using exec for execution to container, /bin/bash for terminal mode.

    docker exec -it ubuntu /bin/bash

Enter a Container to Access Shell in Terminal.

docker exec -it container-name sh

sh for shell terminal

    docker exec -it ubuntu sh

# Run Nginx container for web server

-p for port, My local machine port 8000  maping to with nginx container port 80.   

    docker run -it -d -p 8000:80 nginx

Run a webserver using nginx container with bridge network & mapping port

Access the webserver local Machine ip: http://192.168.106.110:8080/

    docker run -dit --name webserver1 --network bridge -p 8080:80 nginx

Run nginx container with Host Volume & Nginx Defaulf Configuration 

    docker run --name docker-nginx -p 80:80 -v ~/docker-nginx/html:/usr/share/nginx/html -v ~/docker-nginx/default.conf:/etc/nginx/conf.d/default.conf -d nginx


# Add Hostname on a Container

-h for hostname 

    docker run -dit --name ubuntu-nginx -h mail ubuntu

How to Add Hosts file on Container

    docker run --add-host=mail.paulco.xyz:172.17.0.4 -it ubuntu /bin/bash

Adding Multiple Entries in Hosts file on a container

    docker run --add-host=1.example.com:10.0.0.1 --add-host=2.example2.com:10.0.0.2 --add-host=3.example.com:10.0.0.3 ubuntu cat /etc/hosts

Add Hostname & hosts file with port on a Container 

    docker run -dit --name ubuntu-nginx -h mail --add-host=mail.paulco.xyz:172.17.0.3 -p 81:81 ubuntu

# Execute Command from outside of Container

Run a Linux command on a container immediately, without entering the container.

docker exec webserver bash -c "linux command"

    docker exec -it 39361978fd68 bash -c df -h
#### 
    docker exec -it 39361978fd68 bash -c "cat /etc/lsb-release"


# Push Command, when use docker run

    docker run ubuntu bash -c "apt-get -y update" 

    docker run ubuntu bash -c "apt-get -y install nginx" 

Automatically remove the Ubuntu container, when we stop the container.

the --rm flag instructs Docker to automatically remove the Ubuntu Docker container after we stop it.

    docker run -it --rm ubuntu /bin/bash


# Save a Configured Container


#1st run a container then configure as your required and stop the container.
#web1 is old container and web2 is new container which save from web1.

docker stop web1

docker commit web1 web2

#Create a Images from runing container.
#docker commit -m "Container from Image" [Container ID/Name] [NewImage name]
# -m for message, [53d6649f23f6] runiing container id, web1 are new image name

docker commit -m "Container from Image" 53d6649f23f6 web1

+++++++++++++++++++++++++++++++++

++++++++++++++++++++++++++++++++++++++++++++++++++
+ Persisting Data on the Ubuntu Docker Container +
++++++++++++++++++++++++++++++++++++++++++++++++++

#Let's create it in the home directory and name it DockerShare:

mkdir -p DockerShare

#Create a Container with Persist Data using the DockerShare directory.
#Create the /data directory within the Docker container. The /data directory is mapped to the DockerShare folder you created earlier.

docker run -it --rm -v ~/DockerShare:/data ubuntu /bin/bash

++++++++++++++++++++++++++++++++++++++++++++++++++

#How to Rename the Container:
#docker rename container-name new-name

docker rename webserver webserver1

#View Docker Containers

#list Only active containers.

docker ps    

#list all containers active-inactive using -a flag.

docker ps -a   

#list latest container using -l flag.

docker ps -l    

#How to run an existing container.

#Start a Docker Container:
#docker start [container-ID or container-name]
#[5f9478691970] is a container ID [ubuntu] is a container name. we can use container name.

docker start 5f9478691970    
docker start ubuntu

#Restart a Container
docker restart 09ca6feb6efc

#How to execute existing container.
#docker exec -it existing_container_ID_or_name /bin/bash
#[webserver1] is a container name.

docker exec -it webserver1 /bin/bash


#Stop a Docker Container:
#docker stop [container-ID | container-name]
#[5f9478691970] is a container ID. we can use container name.

docker stop 5f9478691970    

#Stop all running Containers:

docker stop $(docker ps -aq)

#Kill a Container

docker kill 09ca6feb6efc

#Remove a Docker Container:
#docker rm [container-ID | container-name]
#[ubuntu] is a container name. we can use container ID.

docker rm ubuntu    

#Remove all Containers

docker rm $(docker ps -aq)

#Remove all Stopped Containers:

docker rm $(docker ps -aq --filter  status="exited")

#Removed all the containers:

docker container prune


#Remove Docker image:
#docker rmi -f <imageId/Name>

docker rmi fce289e99eb9

#Forcefully Remove Image:
#docker rmi -f <imageId/Name>

docker rmi -f fce289e99eb9

#Removing all Images:

docker rmi $(docker images -q)


#Dangling Images:

docker image prune


++++++++++++++++++++++++++++++++ End ++++++++++++++++++++++++++++++++

++++++++++++++++++++++++++++++++
+ Extra Usefull Docker Command +
++++++++++++++++++++++++++++++++

#Display a live stream of container(s) resource usage statistics.
#docker stats [container id/name]

docker stats webserver

#Pause or Suspends all processes in a specified container.

docker pause webserver

#Unpause all processes within one or more containers.

docker unpause webserver

#Copy from a docker container to the local system.
#I am copying index.html file inside a docker container name is  webserver1 to /home/user/.

docker cp webserver1:/usr/share/nginx/html/index.html /home/user/

#Copy from local system to the a docker container.
#I am copying index.html file from my local system to inside a docker container name is  webserver1 to /home/user/.

docker cp index.html webserver1:/usr/share/nginx/html/index.html

#Shows the history of a docker image.

docker history httpd

#Show the logs of the docker container.

docker logs 09ca6feb6efc

#Update container configurations.

docker update --help

#Update the CPU configuration of docker container with container id mentioned in the command.

docker update -c 1 2f6fb3381078

++++++++++++++++++++++++++++++++ End ++++++++++++++++++++++++++++++++


+++++++++++++++++++++++
+  Docker Networking: +
+++++++++++++++++++++++

#Docker Network

docker network

#Listing All Docker Networks

docker network ls

#Inspecting a Docker network:
#docker network inspect networkname 

docker network inspect bridge

#Creating Your Own New Network:
#docker network create --driver <driver-name> <network-name> 
#Docker Works on 3 types of driver by default (bridge, host, null).

docker network create –-driver bridge mynet

#run a container connect with own network

docker run –it –network=mynet ubuntu /bin/bash

#Inspect mynet is create our own network
#When inspect network then we see runing containers network informations.

docker network inspect mynet

#Connect a Container with Docker Network.
#docker network connect <network-name> <container-name or id>

docker network connect bridge webserver

#Disconnect a Container with Docker Network.
#docker network disconnect <network-name> <container-name>

docker network disconnect bridge webserver

#Remove a Docker Network
#docker network rm <network-name>

docker network rm mynet

#Remove all the unused Docker Networks

docker network prune

++++++++++++++++++++++++++++++++ End ++++++++++++++++++++++++++++++++

++++++++++++++++++++++++++
+ Managing Docker Ports  +
++++++++++++++++++++++++++

#Expose our container port for access outside of Docker
# [-p 8080:80] will map TCP port 80 in the container to port 8080 on the Docker host.

docker run -p 8080:80 --name webhost -d nginx

#How To Know Which Port Is Exposed

docker inspect nginx

docker inspect --format="{{.ContainerConfig.ExposedPorts}}" nginx

#Expose Multiple Port on a Container.

docker run -dit --name mailserver -p 8080:80 -p 465:465 -p 25:25 -p 995:995 -p 587:587 -p 143:143 -p 110:110 -p 993:993 ubuntu

#Expose automatic port from local system
#Using Capital [-P] for publish-all, Expose automatic port assign. 

docker run -d --name webserver -P nginx:alpine

++++++++++++++++++++++++++++++++++++++++++++++++++


++++++++++++++++++++++++++++++++++++++++++
+ How To Manage Firewall Port In CentOS  +
++++++++++++++++++++++++++++++++++++++++++
#Check Port Status
netstat -na | grep 55555

#Check Port Status in iptables
iptables-save | grep 55555

#Add the port
vi /etc/services
#service-name  port/protocol  [aliases ...]   [# comment]
testport        55555/tcp   # Application Name

#Open firewall ports
firewall-cmd --zone=public --add-port=55555/tcp --permanent

#firewall-cmd --reload

Ref: https://www.digitalocean.com/community/tutorials/how-to-set-up-a-firewall-using-firewalld-on-centos-7

+++++++++++++++++++++++++++++++++++++++
+ How to Change Nginx Port in Linux   +
+++++++++++++++++++++++++++++++++++++++

#Find nginx source files location.
whereis nginx

1. Open NGINX configuration file
# vi /etc/nginx/sites-enabled/default  [On Debian/Ubuntu]
# vi /etc/nginx/nginx.conf             [On CentOS/RHEL]

2. Change NGINX port number
#Look for the line that begins with listen inside server block. It will look something like

server {
        listen 80 default_server;
        listen [::]:80 default_server;
        ...
Change port number 80 to 8080 in above lines, to look like

server {
        listen 8080 default_server;
        listen [::]:8080 default_server;

3. Check syntax of your updated config file.
nginx -t

4. Restart NGINX
service nginx reload        [On Debian/Ubuntu]
systemctl restart nginx     [On CentOS/RHEL]

#Verify local network sockets table
netstat -tlpn| grep nginx
ss -tlpn| grep nginx

sudo docker run --name docker-nginx -p 80:80 -v ~/docker-nginx/html:/usr/share/nginx/html -v ~/docker-nginx/default.conf:/etc/nginx/conf.d/default.conf -d nginx

+++++++++++++++++++ End Change Nginx Port +++++++++++++++++++++++++++++++

++++++++++++++++++++++++++
+ Install Docker Compose +
++++++++++++++++++++++++++
Reference:
1. https://docs.docker.com/compose/install/linux/#install-the-plugin-manually
2. https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-compose-on-ubuntu-22-04
++++++++++++++++++++++++++++++++++++++++++++++++++

++++++++++++++++++++++++++++
+ Working with Dockerfile  +
++++++++++++++++++++++++++++

mkdir dockerfile && cd dockerfile

#Create a file 
#By default Docker file name is Dockerfile.

nano Dockerfile

# Write a dockerfile

FROM nginx:alpine

#How to build docker file from current location or default name. 
# -t for tag or name, . for define current with default Dockerfile name.

docker build -t imagename .

#How to build docker file from another location or custome name.
#docker build -t imagename -f [filepath] with [filename]

docker build -t myimage -f /home/user/mydockerfile

#Write a dockerfile

FROM nginx:alpine
COPY index.html /usr/share/nginx/html/index.html

#Create a index.html file in current location.

nano index.html

# Dockerfile Instruction

FROM : Using for Pulling Base image
ADD : Using for copy & untar file don't zip to unzip and can download from url link.
COPY : Using for only copy file 
WORKDIR :  Define landing directory in container execution.
WORKDIR /usr/share/nginx/html

ENV: Define environment variable
ENV PWD /usr/share/nginx/html

#Declear ENV Variable
WORKDIR $PWD

RUN : Using for installation
RUN apt-get update -y
RUN apt-get install nginx -y

#We can multiple installation single line using RUN with && .

RUN apt-get update && apt-get upgrade && apt-get install nginx -y


#Example: dockerfile using ADD instruction

#create a folder to tar file
#web is a folder name.

tar -cvf web.tar web

#Write a dockerfile using ADD instruction.

FROM nginx:alpine
ADD web.tar /usr/share/nginx/html/

+++++++++++++++++++++++++++++++++++++++

++++++++++++++++++++++++++++++++++++++++++++++
+ Create a Docker Container with SSH access  +
++++++++++++++++++++++++++++++++++++++++++++++

#Create a Dockerfile

nano Dockerfile

#In that file, paste the following:

####

FROM ubuntu:20.04

RUN apt-get update && apt-get install -y openssh-server

RUN echo 'root:ubuntu' | chpasswd

RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

RUN service ssh restart

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]

####

#Build the Dockerfile

docker build -t myubuntu .

#Run the container

docker run -d -P --name myubuntu myubuntu

#How to locate the IP address of the running container

docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' myubuntu

#SSH Connection into the running container

#ssh root@containerIP or host IP

ssh root@172.17.0.5

+++++++++++++++++++++++++++

++++++++++++++++++++++++++++++++++++++++++++++++++
+ Configure Root User for  SSH in Ubuntu         +
++++++++++++++++++++++++++++++++++++++++++++++++++

#Create or Change Root Password

passwd root

#OR

echo 'root:ubuntu' | chpasswd

#Permit login ssh as root

sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

#OR

nano /etc/ssh/sshd_config

#find the line, comment out and yes
#PermitRootLogin prohibit-password

#Edit like bellow
PermitRootLogin yes

#Restart ssh service
systemctl restart sshd

++++++++++++++++++++++++++++++++++++++++++++++++++
