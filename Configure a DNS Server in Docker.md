# Create & Configure a DNS Server in Docker

#### Pre-Requisites
To follow along with this blog, you'll need the following:

- 1. Linux System with Docker Pre-Installed
- 2. Docker-Compose

Setup Docker Network

Let's create a docker network.
####
    docker network create labnet --subnet 172.24.0.0/16

For our network, we're using a /16 subnet.

DNS Server Configuration

1. First, setup a directory to store our BIND 9 configuration and create a new file called named.conf.options to start configuring the BIND 9 server.
####
    mkdir -p /opt/bind9/configuration
####
    nano /opt/bind9/configuration/named.conf.options

2. Copy the contents below into the file.
####
    options {    
    directory "/var/cache/bind";    
    recursion yes;    
    listen-on { any; };    
    forwarders {            
    8.8.8.8;            
    8.8.4.4;    
    };
    };

3. Next, we'll define a Zone called paulco.xyz, which points to /etc/bind/zones/db. Zone File.

Let's create the file that will define our zone.
####
    nano /opt/bind9/configuration/named.conf.local

Copy the contents below into the file.
####
    zone "paulco.xyz" {    
    type master;    
    file "/etc/bind/zones/paulco.xyz";
    };

The Zone File called db.paulco.xyz contains the domain names that will be managed by our BIND DNS server. We will assign each domain name an IP address. Mention the container's IP address during container runtime so the domain names can point to the corresponding IP addresses.

We'll now add a few domain names to our zone file. Create the lab-net zone file.
####
    nano /opt/bind9/configuration/db.paulco.xyz

4. Copy the contents below into the zone file.
####
    $TTL    604800
    @       IN      SOA     ns1.paulco.xyz. root.paulco.xyz. (
                      3       ; Serial
                 604800     ; Refresh
                  86400     ; Retry
                2419200     ; Expire
                 604800 )   ; Negative Cache TTL
    ;
    ; name servers - NS records
         IN      NS      ns1.paulco.xyz.
    
    ; name servers - A records
    ns1.paulco.xyz.         IN      A      172.24.0.2
    mail.paulco.xyz.        IN      A      172.24.0.3
    app.paulco.xyz.         IN      A      172.24.0.4
    @                       IN       MX 10 mail.paulco.xyz.

In the above example, one name server ns1.paulco.xyz, and two hosts mail.paulco.xyz and www.paulco.xyz have been added.

Build the Docker Image

We'll use the official Docker Image of BIND 9 as a base image and install some additional dependencies into it. Finally, we'll copy our configuration files directly into the Docker image.

Create the Dockerfile.
####
    nano /opt/bind9/Dockerfile.bind9

2. Copy the contents below into the Dockerfile.
####
    #Base Bind9 Image
    FROM ubuntu:latest
    #Install required tools and dependencies
    RUN apt update && apt install -y \  
            bind9 \  
            nano \  
            bind9utils \
            bind9-doc \  
            iputils-ping \
            net-tools
    # Enable IPv4
    #RUN sed -i 's/OPTIONS=.*/OPTIONS="-4 -u bind"/' /etc/default/bind9
    #Copy configuration files
    COPY configuration/named.conf.options /etc/bind/
    COPY configuration/named.conf.local /etc/bind/
    COPY configuration/db.paulco.xyz /etc/bind/zones/
    # Expose Ports
    EXPOSE 53/tcp
    EXPOSE 53/udp
    EXPOSE 953/tcp
    # Start the Name Service
    CMD ["/usr/sbin/named", "-g", "-c", "/etc/bind/named.conf", "-u", "bind"]

3. Build and tag the BIND image using the command below.
####
    docker build -t mydns . -f Dockerfile.bind9

Run the Docker Container

Once our container has been successfully built, we will now run it in our lab-net network with an explicitly mentioned IP address.
####
    docker run -d -h=ns1.paulco.xyz --add-host=ns1.paulco.xyz:172.24.0.2 -p 53:53/tcp -p 53:53/udp -p 127.0.0.1:953:953/tcp --rm --name=dnsserver --net=labnet --ip=172.24.0.2 mydns

Then enable the bind9 daemon:

docker exec -d dnsserver /etc/init.d/bind9 start

Verifying server configuration:
####
    docker exec -it dnsserver /bin/bash

Check DNS & MX record from locally in mail server:
####
    dig paulco.xyz mx
    dig paulco.xyz any
    dig +short MX paulco.xyz
    dig +short A paulco.xyz
####
    host -t mx paulco.xyz
    host -t a mail.paulco.xyz

Edit /etc/resolv.conf
####
    tee /etc/resolv.conf << END
    nameserver 127.0.0.1
    nameserver 172.24.0.2
    END

named-check
confnamed-checkzone paulco.xyz /etc/bind/zones/db.paulco.xyz
zone paulco.xyz/IN: loaded serial 3
OK

Error runing up on DNS Container

docker: Error response from daemon: driver failed programming external connectivity on endpoint dnsserver (7447b9f...): Error starting userland proxy: listen tcp4 0.0.0.0:53: bind: address already in use.

Solution:
####
    nano /etc/systemd/resolved.conf
    
Find bellow line:

#DNSStubListener=yes

Uncomment and no:
####
    DNSStubListener=no

Restart systemd-resolved
####
    systemctl restart systemd-resolved

Demo Setup

We can now use the previously started DNS container as our DNS server. Any services we need domain mapping for can simply be rebuilt with the required domain names.

Run a container for Mail Server under Existing DNS server:

docker run -d --rm --name=mail --net=labnet --ip=172.24.0.3 --dns=172.24.0.2 centos
####
    docker run -dit --name zimbra --net=labnet --ip=172.24.0.3 --dns=172.24.0.2 -h mail.paulco.xyz --add-host=mail.paulco.xyz:172.24.0.3 -p 80:80 -p 8080:8080 -p 443:443 -p 25:25 -p 465:465 -p 587:587 -p 993:993 -p 995:995 -p 7071:7071 -p 8443:8443 -p 7143:7143 -p 7110:7110 zimbramail

Execute the myzimbra container

    docker exec -it zimbra /bin/bash

Run a container for web Server under Existing DNS server:

    docker run -d --rm --name=web --net=labnet --ip=172.24.0.4 --dns=172.24.0.2 httpd:latest

As you can see, all containers now run on the same network.

    docker network inspect labnet

Check dns client container

    docker exec -it mail nslookup mail.paulco.xyz 
####
< Server:         127.0.0.11
< Address:        127.0.0.11:53
<
< Name:   mail.paulco.xyz
< Address: 172.24.0.4


