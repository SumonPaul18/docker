# Working With Docker & Containers – Complete Step-by-Step Guide

This guide is based on your uploaded file. All commands and topics have been organized **step-by-step**, grouped by **topic**, and written in **simple English**. Each command is clearly separated and explained so you can follow along easily.

---

## 🔍 1. Docker System Information

Check basic info about Docker.

```bash
# Show detailed Docker system info
docker info
```

```bash
# Check Docker version
docker --version
```

---

## 📦 2. Docker Images

### 🔎 Search for an Image
Search Docker Hub for available images.

```bash
docker search ubuntu
```

---

### 📥 Pull (Download) an Image
Download an image from Docker Hub.

```bash
docker pull ubuntu
```

> If you don’t pull first, `docker run` will automatically download it.

---

### 🖼️ List All Downloaded Images
See all images saved on your computer.

```bash
docker images
```

---

### 🗑️ Remove an Image
Delete a downloaded image.

```bash
docker rmi fce289e99eb9
```

> Replace `fce289e99eb9` with the actual image ID or name.

---

### 🚫 Force Remove an Image
Remove even if the image is being used.

```bash
docker rmi -f fce289e99eb9
```

---

### 🗑️ Remove All Images
Delete all downloaded images.

```bash
docker rmi $(docker images -q)
```

---

### 🧹 Clean Up Unused Images
Remove unused ("dangling") images.

```bash
docker image prune
```

To remove all unused images (not just dangling ones):

```bash
docker image prune -a
```

---

## 🐳 3. Run Docker Containers

### ▶️ Run a Container (Non-Interactive)
Start a container and run default command.

```bash
docker run ubuntu
```

> This runs and exits immediately.

---

### 🏷️ Run with Custom Name
Give your container a name.

```bash
docker run --name myubuntu ubuntu
```

---

### 🖥️ Run with Interactive Shell Access
Enter the container like a real Linux terminal.

```bash
docker run -it ubuntu /bin/bash
```

> Use `/bin/bash` if available, or `/bin/sh` for smaller images.

---

### 🔄 Exit Without Stopping Container
Leave the container running.

```text
Press: Ctrl + P, then Ctrl + Q
```

> This detaches from the container without stopping it.

---

### 🚪 Exit and Stop Container
Close the container.

```bash
exit
```

---

### 🏷️ Run with Tag (Specific Version)
Run a specific version of an image.

```bash
docker run -it ubuntu:latest /bin/bash
```

You can use any tag: `ubuntu:20.04`, `nginx:alpine`, etc.

---

### 🧊 Run in Background (Detached Mode)
Run container in the background.

```bash
docker run -it -d ubuntu bash
```

> `-d` means "detached" — runs in background.

---

### 🔄 Re-enter a Running Container
Go back into a running container.

```bash
docker exec -it ubuntu /bin/bash
```

Or by name:

```bash
docker exec -it myubuntu /bin/bash
```

---

### 🖥️ Run with Shell (sh)
Use `sh` if `bash` is not installed.

```bash
docker exec -it ubuntu /bin/sh
```

---

### 🌐 Run Nginx Web Server
Start Nginx and map port 8000 (host) → 80 (container).

```bash
docker run -it -d -p 8000:80 nginx
```

> Access at: `http://localhost:8000`

---

### 🌐 Run Web Server with Name & Network
Start Nginx with name, bridge network, and port.

```bash
docker run -dit --name webserver1 --network bridge -p 8080:80 nginx
```

> Access at: `http://192.168.106.110:8080` (use your host IP)

---

### 📁 Run Nginx with Volume (Shared Folder)
Mount local folders into the container.

```bash
docker run --name docker-nginx \
  -p 80:80 \
  -v ~/docker-nginx/html:/usr/share/nginx/html \
  -v ~/docker-nginx/default.conf:/etc/nginx/conf.d/default.conf \
  -d nginx
```

> This shares HTML files and config from your computer.

---

### 🏷️ Set Hostname in Container
Give the container a custom hostname.

```bash
docker run -dit --name ubuntu-nginx -h mail ubuntu
```

> `-h mail` sets hostname to `mail`.

---

### 📁 Add Hosts File Entry
Add custom IP-to-hostname mapping.

```bash
docker run --add-host=mail.paulco.xyz:172.17.0.4 -it ubuntu /bin/bash
```

> This adds `mail.paulco.xyz` pointing to `172.17.0.4` in `/etc/hosts`.

---

### 📁 Add Multiple Hosts Entries
Add more than one host entry.

```bash
docker run \
  --add-host=1.example.com:10.0.0.1 \
  --add-host=2.example2.com:10.0.0.2 \
  --add-host=3.example.com:10.0.0.3 \
  ubuntu cat /etc/hosts
```

> Shows `/etc/hosts` with all entries.

---

### 🏷️ + 📁 + 🌐 Combine: Hostname, Hosts, and Port
Full example with all options.

```bash
docker run -dit \
  --name ubuntu-nginx \
  -h mail \
  --add-host=mail.paulco.xyz:172.17.0.3 \
  -p 81:81 \
  ubuntu
```

---

## 💡 4. Run Commands Without Entering Container

### ⚙️ Run a Command Inside Container
Run a Linux command without entering.

```bash
docker exec webserver bash -c "df -h"
```

---

### 📄 View OS Info
Check what OS is inside the container.

```bash
docker exec -it 39361978fd68 bash -c "cat /etc/lsb-release"
```

---

### 📥 Update Packages
Update inside Ubuntu container.

```bash
docker run ubuntu bash -c "apt-get -y update"
```

---

### 📦 Install Software
Install Nginx in Ubuntu container.

```bash
docker run ubuntu bash -c "apt-get -y install nginx"
```

> Note: Changes are lost when container stops unless you commit.

---

### 🚫 Auto-Remove Container After Use
Use temporary container (clean up automatically).

```bash
docker run -it --rm ubuntu /bin/bash
```

> `--rm` removes container when you exit.

---

## 💾 5. Save & Reuse Containers

### 🖼️ Save Configured Container as New Image
After making changes, save as a new image.

```bash
docker stop web1
docker commit web1 web2
```

> `web1` is old container, `web2` is new image.

---

### 🖼️ Commit with Message
Add a note when saving.

```bash
docker commit -m "Installed Nginx" 53d6649f23f6 web1
```

> Good for tracking changes.

---

## 💾 6. Persist Data (Volumes)

### 📁 Create Shared Folder
Make a folder to share with container.

```bash
mkdir -p ~/DockerShare
```

---

### 📁 Mount Folder into Container
Link host folder to container.

```bash
docker run -it --rm -v ~/DockerShare:/data ubuntu /bin/bash
```

> Anything in `/data` inside container is saved in `~/DockerShare` on host.

---

## 🔁 7. Manage Containers

### 🔄 Rename a Container
Change container name.

```bash
docker rename webserver webserver1
```

---

### 📋 List Containers
See running containers.

```bash
docker ps
```

---

### 📋 List All Containers (Running + Stopped)
Show all containers.

```bash
docker ps -a
```

---

### 📋 Show Last Created Container
Only show the most recent one.

```bash
docker ps -l
```

---

### ▶️ Start a Stopped Container
Restart a container.

```bash
docker start ubuntu
```

> Use container name or ID.

---

### 🔁 Restart a Container
Restart running container.

```bash
docker restart 09ca6feb6efc
```

---

### ⚙️ Execute Command in Running Container
Run command without entering.

```bash
docker exec -it webserver1 /bin/bash
```

---

### ⏹️ Stop a Container
Gracefully stop a container.

```bash
docker stop 5f9478691970
```

---

### ⏹️ Stop All Running Containers
Stop all containers at once.

```bash
docker stop $(docker ps -aq)
```

---

### 💥 Kill a Container Immediately
Force stop (not graceful).

```bash
docker kill 09ca6feb6efc
```

---

### 🗑️ Remove a Container
Delete a stopped container.

```bash
docker rm ubuntu
```

---

### 🗑️ Remove All Containers
Delete all containers (must be stopped).

```bash
docker rm $(docker ps -aq)
```

---

### 🗑️ Remove All Stopped Containers
Only remove stopped ones.

```bash
docker rm $(docker ps -aq --filter status=exited)
```

---

### 🧹 Remove All Unused Containers
Clean up stopped containers.

```bash
docker container prune
```

---

## 🌐 8. Docker Networking

### 📋 List All Networks
See all Docker networks.

```bash
docker network ls
```

---

### 🔍 Inspect a Network
View details of a network.

```bash
docker network inspect bridge
```

---

### ➕ Create a Custom Network
Make your own bridge network.

```bash
docker network create --driver bridge mynet
```

---

### 🔗 Connect Container to Custom Network
Run container on your network.

```bash
docker run -it --network=mynet ubuntu /bin/bash
```

---

### 🔗 Connect Running Container to Network
Add existing container to network.

```bash
docker network connect bridge webserver
```

---

### 🔓 Disconnect Container from Network
Remove from network.

```bash
docker network disconnect bridge webserver
```

---

### 🗑️ Remove a Network
Delete unused network.

```bash
docker network rm mynet
```

---

### 🧹 Remove All Unused Networks
Clean up.

```bash
docker network prune
```

---

## 🌐 9. Docker Ports

### 🔄 Map Port (Host → Container)
Map port 8080 (host) to 80 (container).

```bash
docker run -p 8080:80 --name webhost -d nginx
```

---

### 🔍 Check Exposed Ports of Image
See what ports an image uses.

```bash
docker inspect --format='{{.ContainerConfig.ExposedPorts}}' nginx
```

---

### 🔄 Map Multiple Ports
Open many ports at once.

```bash
docker run -dit \
  --name mailserver \
  -p 8080:80 \
  -p 25:25 \
  -p 587:587 \
  -p 465:465 \
  -p 143:143 \
  -p 110:110 \
  -p 993:993 \
  -p 995:995 \
  ubuntu
```

---

### 🔁 Auto-Assign Port (Random)
Let Docker pick a random port.

```bash
docker run -d --name webserver -P nginx:alpine
```

> Use `docker port webserver` to see assigned port.

---

## 🔐 10. Firewall & Port (CentOS/RHEL)

### 🔍 Check if Port is Open
```bash
netstat -na | grep 55555
```

---

### 🔍 Check iptables
```bash
iptables-save | grep 55555
```

---

### ➕ Add Port to Services File (Optional)
```bash
sudo nano /etc/services
```

Add line:
```
testport        55555/tcp   # My App
```

---

### 🔓 Open Port in Firewall (firewalld)
```bash
sudo firewall-cmd --zone=public --add-port=55555/tcp --permanent
sudo firewall-cmd --reload
```

> Reference: [DigitalOcean firewalld Guide](https://www.digitalocean.com/community/tutorials/how-to-set-up-a-firewall-using-firewalld-on-centos-7)

---

## 🛠️ 11. Change Nginx Port

### 🔍 Find Nginx Location
```bash
whereis nginx
```

---

### 📂 Edit Config File
On Ubuntu/Debian:
```bash
sudo nano /etc/nginx/sites-enabled/default
```

On CentOS/RHEL:
```bash
sudo nano /etc/nginx/nginx.conf
```

---

### ✏️ Change Listen Port
From:
```nginx
listen 80 default_server;
```
To:
```nginx
listen 8080 default_server;
```

---

### ✅ Test Config
```bash
nginx -t
```

---

### 🔁 Restart Nginx
On Ubuntu:
```bash
sudo service nginx reload
```

On CentOS:
```bash
sudo systemctl restart nginx
```

---

### 🔍 Verify Port
```bash
netstat -tlpn | grep nginx
```
or
```bash
ss -tlpn | grep nginx
```

---

## 🧩 12. Docker Compose (Install)

### 📥 Install Docker Compose Manually
```bash
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
```

### 🔧 Make Executable
```bash
sudo chmod +x /usr/local/bin/docker-compose
```

### ✅ Test Installation
```bash
docker-compose --version
```

> Reference: [Docker Compose Install Guide](https://docs.docker.com/compose/install/linux/#install-the-plugin-manually)

---

## 🧱 13. Build Custom Images (Dockerfile)

### 📁 Create Folder
```bash
mkdir dockerfile && cd dockerfile
```

---

### 📄 Create Dockerfile
```bash
nano Dockerfile
```

Add:
```Dockerfile
FROM nginx:alpine
COPY index.html /usr/share/nginx/html/index.html
```

---

### 📄 Create index.html
```bash
echo "<h1>Hello from Docker!</h1>" > index.html
```

---

### 🛠️ Build Image
```bash
docker build -t mywebapp .
```

> `-t` = tag name, `.` = current directory.

---

### 🛠️ Build with Custom File Name/Path
```bash
docker build -t myimage -f /home/user/mydockerfile
```

---

### 🧱 Dockerfile Instructions

| Command | Purpose |
|--------|--------|
| `FROM` | Base image (e.g., `ubuntu`, `nginx`) |
| `COPY` | Copy files from host to container |
| `ADD` | Like COPY, but can download URLs and extract `.tar` files |
| `WORKDIR` | Set current directory inside container |
| `ENV` | Set environment variable |
| `RUN` | Run command during build |
| `CMD` | Default command when container starts |
| `EXPOSE` | Document which port to use |
| `VOLUME` | Define shared data folder |

---

### 📦 Example: Use ADD to Extract .tar
Create tar file:
```bash
tar -cvf web.tar web/
```

Dockerfile:
```Dockerfile
FROM nginx:alpine
ADD web.tar /usr/share/nginx/html/
```

---

## 🔐 14. SSH Access in Docker Container

### 📄 Create Dockerfile for SSH
```bash
nano Dockerfile
```

Paste:
```Dockerfile
FROM ubuntu:20.04
RUN apt-get update && apt-get install -y openssh-server
RUN echo 'root:ubuntu' | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
```

---

### 🛠️ Build Image
```bash
docker build -t myubuntu-ssh .
```

---

### ▶️ Run Container
```bash
docker run -d -P --name myssh myubuntu-ssh
```

> `-P` assigns random port for SSH.

---

### 🌐 Get Container IP
```bash
docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' myssh
```

---

### 🔐 SSH Into Container
```bash
ssh root@172.17.0.5
```

> Use the IP from above.

---

## 🔐 15. Enable Root SSH in Running Ubuntu Container

### 🔐 Set Root Password
```bash
passwd root
```
or
```bash
echo 'root:ubuntu' | chpasswd
```

---

### 🔐 Allow Root Login
```bash
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
```

Or edit manually:
```bash
nano /etc/ssh/sshd_config
```
Change:
```
PermitRootLogin yes
```

---

### 🔁 Restart SSH
```bash
systemctl restart sshd
```

---

## 📦 16. Extra Useful Docker Commands

### 📊 View Live Resource Usage
```bash
docker stats webserver
```

---

### ⏸️ Pause Container
```bash
docker pause webserver
```

---

### ▶️ Resume Container
```bash
docker unpause webserver
```

---

### 📁 Copy File from Container to Host
```bash
docker cp webserver1:/usr/share/nginx/html/index.html /home/user/
```

---

### 📁 Copy File from Host to Container
```bash
docker cp index.html webserver1:/usr/share/nginx/html/index.html
```

---

### 📜 View Image Build History
```bash
docker history httpd
```

---

### 📜 View Container Logs
```bash
docker logs 09ca6feb6efc
```

---

### 🛠️ Update Container Settings
```bash
docker update --help
```

Example: Change CPU shares
```bash
docker update -c 1 2f6fb3381078
```

---

## ✅ Final Notes

- Always use meaningful names for containers and images.
- Use `--rm` for test containers to auto-clean.
- Use volumes (`-v`) to save data.
- Use `docker exec` instead of SSH when possible.
- Use `Dockerfile` + `docker build` for repeatable setups.
- Use `docker-compose` for multi-container apps.

---
