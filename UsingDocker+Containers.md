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

## 🔧 **Additional Docker Commands & Best Practices**

### 📂 17. Use `.dockerignore` File (Like `.gitignore`)
Prevent unwanted files from being copied into the image.

```bash
# Create .dockerignore
nano .dockerignore
```

Add:
```
# Ignore node modules
node_modules/

# Ignore logs
*.log

# Ignore environment files
.env

# Ignore IDE files
.DS_Store
.vscode/
.idea/
```

> ✅ Best Practice: Always use `.dockerignore` when building images.

---

### 🛠️ 18. Build Image with Build Arguments (`ARG`)
Pass values at build time.

```Dockerfile
# In Dockerfile
ARG APP_ENV=development
ENV APP_ENV=$APP_ENV

RUN echo "Building for $APP_ENV environment"
```

Build with argument:
```bash
docker build --build-arg APP_ENV=production -t myapp:prod .
```

---

### 🧱 19. Multi-Stage Builds (Reduce Image Size)
Use one stage to build, another to run.

```Dockerfile
# Stage 1: Build
FROM node:16 AS builder
WORKDIR /app
COPY package.json .
RUN npm install
COPY . .
RUN npm run build

# Stage 2: Run
FROM nginx:alpine
COPY --from=builder /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

Build:
```bash
docker build -t mywebapp .
```

> ✅ Result: Small final image, no Node.js or build tools included.

---

### 🔄 20. Restart Policies (Auto-Start Containers)
Make containers restart automatically.

```bash
# Always restart
docker run -d --restart=always --name web nginx

# Restart only on failure
docker run -d --restart=on-failure:3 --name web nginx

# No restart (default)
docker run -d --restart=no --name web nginx
```

> Useful for production services.

---

### 📁 21. Named Volumes (Better than Bind Mounts)
Let Docker manage storage.

```bash
# Create a named volume
docker volume create app-data

# Use in container
docker run -d -v app-data:/var/lib/mysql --name mysql mysql
```

List volumes:
```bash
docker volume ls
```

Inspect:
```bash
docker volume inspect app-data
```

Remove unused:
```bash
docker volume prune
```

> ✅ Best Practice: Use named volumes for databases.

---

### 🌐 22. Custom Network with Subnet & Gateway
Create advanced networks.

```bash
docker network create \
  --driver bridge \
  --subnet=192.168.100.0/24 \
  --gateway=192.168.100.1 \
  mynetwork
```

Run container on it:
```bash
docker run -it --network=mynetwork ubuntu /bin/bash
```

---

### 🧯 23. Clean Up Everything (Full Reset)
Remove **all** unused objects at once.

```bash
docker system prune -a --volumes
```

> ⚠️ Warning: Removes all unused containers, images, networks, **and volumes**.

Use safely:
```bash
docker system prune        # Only unused stuff
docker system prune -a     # Also removes unused images
```

---

### 📊 24. View Real-Time Logs
Follow logs like `tail -f`.

```bash
docker logs -f webserver
```

Show last 50 lines:
```bash
docker logs --tail 50 webserver
```

---

### 🐍 25. Run Python App in Container
Quick way to test a Python script.

```bash
# Run Python 3 and enter shell
docker run -it python:3.9 /bin/bash

# Run a Python script directly
echo 'print("Hello from Docker!")' > hello.py
docker run -v $(pwd):/app -w /app python:3.9 python hello.py
```

> `-w /app` sets working directory.

---

### 📦 26. Export & Import Images (No Docker Hub)
Save image as file and share.

```bash
# Save image to tar file
docker save -o myimage.tar mywebapp:latest

# Load image on another machine
docker load -i myimage.tar
```

> Useful for offline environments.

---

### 🚚 27. Export & Import Containers
Save container state as image.

```bash
# Export stopped container
docker export web1 > web1-container.tar

# Import as image
cat web1-container.tar | docker import - web1-restored:latest
```

> Note: `export` removes history; use `commit` for full image.

---

### 🔐 28. Run Container as Non-Root User
More secure.

```Dockerfile
FROM ubuntu:20.04
RUN useradd -m myuser
USER myuser
CMD ["sleep", "3600"]
```

Or at runtime:
```bash
docker run -it --user 1000 ubuntu /bin/bash
```

> ✅ Best Practice: Avoid running as root in production.

---

### 🧩 29. Docker Compose – Advanced Example
Create `docker-compose.yml`:

```yaml
version: '3'
services:
  web:
    image: nginx:alpine
    ports:
      - "80:80"
    volumes:
      - ./html:/usr/share/nginx/html
    depends_on:
      - app
  app:
    build: .
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=production
  db:
    image: mysql:8.0
    environment:
      MYSQL_ROOT_PASSWORD: rootpass
      MYSQL_DATABASE: myapp
    volumes:
      - db-data:/var/lib/mysql

volumes:
  db-data:
```

Run:
```bash
docker-compose up -d
```

Stop:
```bash
docker-compose down
```

---

### 🧪 30. Run Tests in Container
Run one-time command for testing.

```bash
docker run --rm ubuntu bash -c "apt-get update && echo 'Test Passed'"
```

> `--rm` ensures cleanup after test.

---

### 📁 31. Check Disk Usage
See how much space Docker is using.

```bash
docker system df
```

Output:
```
TYPE            TOTAL     ACTIVE    SIZE      RECLAIMABLE
Images          5         3         1.2GB     800MB (66%)
Containers      10        2         300MB     250MB (83%)
Local Volumes   3         1         500MB     400MB (80%)
Build Cache     -         -         200MB     200MB
```

---

### 🧰 32. Inspect Any Object (Container, Image, Network, Volume)
Get detailed JSON info.

```bash
docker inspect webserver
docker inspect nginx
docker inspect bridge
docker inspect app-data
```

Filter specific field:
```bash
docker inspect webserver --format='{{.NetworkSettings.IPAddress}}'
```

---

### 🧹 33. Remove All Unused Objects (Safe Cleanup)
```bash
docker system prune
```

Interactive prompt will ask:
```
WARNING! This will remove:
  - all stopped containers
  - all networks not used by at least one container
  - all dangling images
  - all build cache

Are you sure? [y/N]
```

Add `-f` to skip prompt:
```bash
docker system prune -f
```

---

### 📂 34. Mount Read-Only Volume
Prevent changes from container.

```bash
docker run -v ~/config:/app/config:ro nginx
```

> `:ro` = read-only. Useful for config files.

---

### 🧯 35. Stop & Remove Container in One Command
```bash
docker stop webserver && docker rm webserver
```

Or use `--rm` when running:
```bash
docker run --rm -it ubuntu /bin/bash
```

---

### 🧭 36. List All Container IDs Only
Useful for scripts.

```bash
docker ps -aq
```

Stop and remove all:
```bash
docker stop $(docker ps -aq) && docker rm $(docker ps -aq)
```

---

## ✅ **Best Practices Summary (Updated)**

| Practice | Why It's Important |
|--------|-------------------|
| ✅ Use `--rm` for test containers | Auto cleanup |
| ✅ Use named volumes for data | Better management |
| ✅ Use `.dockerignore` | Faster builds |
| ✅ Use multi-stage builds | Smaller images |
| ✅ Avoid `latest` tag | Predictable deployments |
| ✅ Use `docker-compose.yml` | Manage multi-container apps |
| ✅ Run as non-root user | Security |
| ✅ Use `restart: unless-stopped` | Auto-healing |
| ✅ Clean up with `prune` | Save disk space |
| ✅ Use `EXPOSE` and `CMD` | Clear image metadata |

---

## 📚 Final Tips

- Always name your containers (`--name`).
- Use tags: `myapp:v1`, `myapp:prod`, not just `myapp`.
- Never store secrets in Dockerfiles.
- Use `docker logs`, `docker stats`, `docker inspect` daily.
- Learn `docker-compose` — it's essential for real apps.
- Keep your base images updated (e.g., `alpine`, `ubuntu:22.04`).

---
## 🔐 37. **Docker Security Best Practices**

### ✅ Why It Matters
Running containers as root or with full privileges can be dangerous. If a container is compromised, the attacker could access the host system.

### 🛡️ How to Secure Your Containers

#### ➤ Run as Non-Root User (Recommended)
```Dockerfile
FROM ubuntu:20.04
RUN useradd -m appuser
USER appuser
CMD ["sleep", "3600"]
```

Or at runtime:
```bash
docker run -it --user 1000 ubuntu /bin/bash
```

> `1000` = user ID on host.

---

#### ➤ Drop All Capabilities
Remove all Linux capabilities by default.

```bash
docker run --cap-drop=all ubuntu
```

Then add only what you need:
```bash
docker run --cap-drop=all --cap-add=NET_BIND_SERVICE nginx
```

> Allows binding to port 80 without full root access.

---

#### ➤ Read-Only Filesystem
Prevent changes inside container.

```bash
docker run --read-only ubuntu touch /test
# Will fail: no write access
```

Use temporary space:
```bash
docker run --read-only --tmpfs /tmp ubuntu ls /tmp
```

---

#### ➤ Disable Inter-Process Communication (IPC)
```bash
docker run --ipc=none ubuntu
```

Prevents shared memory attacks.

---

#### ➤ Limit Resources (CPU & Memory)
Avoid one container using all system resources.

```bash
# Limit to 512MB RAM
docker run -m 512m nginx

# Limit to 1 CPU core
docker run --cpus=1 nginx

# Combine both
docker run -m 512m --cpus=0.5 nginx
```

> Useful for multi-tenant servers.

---

## 🧩 38. **Docker Compose Advanced Features**

### 📄 Use `.env` File for Environment Variables
Create `.env`:
```env
DB_USER=admin
DB_PASS=secret123
WEB_PORT=8080
```

Use in `docker-compose.yml`:
```yaml
version: '3'
services:
  db:
    image: mysql:8.0
    environment:
      MYSQL_ROOT_PASSWORD: ${DB_PASS}
```

> Docker Compose automatically loads `.env`.

---

### 🔁 Use Profiles to Control Services
Only start some services when needed.

```yaml
version: '3.8'
services:
  web:
    image: nginx
    ports:
      - "80:80"
  db:
    image: mysql:8.0
    profiles: 
      - dev
      - database
  redis:
    image: redis
    profiles: 
      - cache
```

Start only web:
```bash
docker-compose up web
```

Start web + db:
```bash
docker-compose --profile dev up
```

---

### 🔄 Restart Policies in Compose
Make services auto-restart.

```yaml
services:
  web:
    image: nginx
    restart: unless-stopped
```

Options:
- `no` – Never restart
- `on-failure` – Only if fails
- `always` – Always restart
- `unless-stopped` – Always, unless manually stopped

> Best for production.

---

## 🧱 39. **BuildKit: Faster & Smarter Builds**

### ✅ Enable BuildKit
Set environment variable:
```bash
export DOCKER_BUILDKIT=1
```

Or run:
```bash
DOCKER_BUILDKIT=1 docker build -t myapp .
```

> Faster builds, better caching, colored output.

---

### 🧩 Use `# syntax=docker/dockerfile:1`
Add to top of Dockerfile:
```Dockerfile
# syntax=docker/dockerfile:1
FROM ubuntu:20.04
RUN apt-get update && apt-get install -y curl
```

Enables advanced features like:
- `RUN --mount=type=cache`
- Secret mounting
- Conditional logic

---

### 🗃️ Cache Dependencies (Node.js Example)
```Dockerfile
# syntax=docker/dockerfile:1
FROM node:16

WORKDIR /app

# Copy package files first
COPY package*.json ./

# Install with cache mount
RUN --mount=type=cache,target=/root/.npm \
    npm ci --only=production

COPY . .

EXPOSE 3000
CMD ["node", "server.js"]
```

> Speeds up rebuilds by reusing `node_modules`.

---

## 🔐 40. **Secret Management (For Production)**

### ❌ Never Do This
```Dockerfile
ENV DB_PASSWORD=mypassword
```

Passwords end up in image history!

---

### ✅ Use Docker Secrets (With Swarm)
Create secret:
```bash
echo "mypassword" | docker secret create db_pass -
```

Use in `docker-compose.yml`:
```yaml
version: '3.8'
services:
  db:
    image: mysql:8.0
    environment:
      MYSQL_ROOT_PASSWORD_FILE: /run/secrets/db_pass
    secrets:
      - db_pass

secrets:
  db_pass:
    external: true
```

> Only works in **Swarm mode**.

---

### ✅ Use `.env` + `environment:` (For Dev)
```yaml
environment:
  - DB_PASSWORD=${DB_PASS}
```

And `.env`:
```env
DB_PASS=mysecretpassword
```

> Never commit `.env` to Git.

---

## 🌐 41. **Docker Swarm (Basic Cluster Setup)**

### ➤ Initialize Swarm
```bash
docker swarm init
```

> Turns your machine into a manager node.

---

### ➤ Create a Service (Instead of Container)
```bash
docker service create --name web -p 80:80 nginx
```

> Like `docker run`, but scalable.

---

### ➤ Scale the Service
```bash
docker service scale web=3
```

> Runs 3 copies of Nginx.

---

### ➤ Update Service (Zero Downtime)
```bash
docker service update --image nginx:alpine web
```

> Rolling update.

---

### ➤ Leave Swarm
```bash
docker swarm leave --force
```

---

## 🧪 42. **Health Checks in Docker**

### ✅ Why Use Health Checks?
Know if your app inside container is actually working.

### 🛠️ Add to Dockerfile
```Dockerfile
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost/ || exit 1
```

Or in `docker run`:
```bash
docker run \
  --health-cmd="curl -f http://localhost || exit 1" \
  --health-interval=30s \
  --health-retries=3 \
  nginx
```

Check status:
```bash
docker inspect <container> | grep -i health
```

> Shows: `healthy`, `unhealthy`, or `starting`.

---

## 📁 43. **Bind Mounts vs Named Volumes – When to Use Which?**

| Feature | Bind Mount | Named Volume |
|--------|-----------|---------------|
| Location | Host path (`~/data`) | Docker-managed (`/var/lib/docker/volumes/`) |
| Portability | ❌ Not portable | ✅ Portable |
| Backup | Manual | Easy with volume tools |
| Use Case | Config files, dev code | Databases, persistent data |

### ✅ Best Practice
- Use **bind mounts** for config/code during development.
- Use **named volumes** for databases and production data.

---

## 🧰 44. **Debugging Tips & Tricks**

### 🔍 See What’s Inside a Running Container
```bash
docker exec -it mycontainer ps aux
```

See network:
```bash
docker exec -it mycontainer ip a
```

Check disk:
```bash
docker exec -it mycontainer df -h
```

---

### 📦 Inspect Image Layers
See how much space each layer uses:
```bash
docker history nginx
```

---

### 🐞 Run BusyBox for Debugging
```bash
docker run -it --rm busybox sh
```

Tiny Linux environment for testing networks, files, etc.

---

### 📜 View Logs with Timestamps
```bash
docker logs -f --timestamps webserver
```

---

## 🔄 45. **Automate with Shell Scripts**

### 🧹 Auto-Cleanup Script
Save as `clean-docker.sh`:
```bash
#!/bin/bash
echo "Stopping all containers..."
docker stop $(docker ps -aq)

echo "Removing all containers..."
docker rm $(docker ps -aq)

echo "Removing unused images..."
docker image prune -a -f

echo "Removing unused volumes..."
docker volume prune -f

echo "Cleanup complete!"
```

Make executable:
```bash
chmod +x clean-docker.sh
```

Run:
```bash
./clean-docker.sh
```

> Great for CI/CD or local cleanup.

---

## 📚 Final Words: From Beginner to Pro

| Level | What You Should Know |
|------|------------------------|
| 🔹 Beginner | `run`, `ps`, `exec`, `build`, `pull` |
| 🔹🔹 Intermediate | `volumes`, `networks`, `Dockerfile`, `compose` |
| 🔹🔹🔹 Advanced | `security`, `health checks`, `BuildKit`, `Swarm`, `secrets` |

---

## 🎯 Summary: Advanced Docker Checklist

✅ Run containers as non-root  
✅ Use `--cap-drop=all` and add only needed caps  
✅ Limit CPU & memory usage  
✅ Use `.dockerignore` and `.env`  
✅ Use named volumes for databases  
✅ Use multi-stage builds  
✅ Use health checks  
✅ Use Docker Compose profiles  
✅ Enable BuildKit for faster builds  
✅ Never store secrets in Dockerfiles  
✅ Clean up with `prune` regularly  

---
## 🐳 46. Working with Docker Hub (Push & Pull Images)

Docker Hub is like GitHub, but for Docker images. You can **upload (push)** your custom images and **download (pull)** them from any machine.

### 🔐 Step 1: Create a Docker Hub Account
Go to: [https://hub.docker.com](https://hub.docker.com)  
Sign up with your email or GitHub.

> Example username: `paulco`

---

### 🔐 Step 2: Login from Command Line
```bash
docker login
```

Enter your Docker Hub **username** and **password**.

> ✅ Success: `Login Succeeded`

---

### 🏷️ Step 3: Tag Your Image (Required for Push)
You must tag your image as:  
`username/repository-name:tag`

Example:
```bash
docker tag mywebapp paulco/mywebapp:v1
```

> This does **not** create a new image. It just adds a label.

---

### 🚀 Step 4: Push Image to Docker Hub
```bash
docker push paulco/mywebapp:v1
```

> Wait for upload to complete.

Now anyone can use your image:
```bash
docker pull paulco/mywebapp:v1
```

---

### 📥 Step 5: Pull from Docker Hub
To download someone else’s image:
```bash
docker pull nginx
```

Or a specific user’s image:
```bash
docker pull paulco/mywebapp:v1
```

Then run it:
```bash
docker run -d -p 8080:80 paulco/mywebapp:v1
```

---

### 🧹 Optional: Remove Local Image Before Pulling
```bash
docker rmi paulco/mywebapp:v1
docker pull paulco/mywebapp:v1
```

---

## 🔐 47. Secure Your Docker Hub Login (Use Token)

⚠️ Never use your password directly on shared or cloud machines.

### ✅ Use Access Token Instead
1. Go to: [https://hub.docker.com/settings/security](https://hub.docker.com/settings/security)
2. Click: **New Access Token**
3. Copy the token (e.g., `abc123xyz`)
4. Login using token:
```bash
docker login -u paulco
# When asked for password, paste the token
```

> ✅ Safer than using real password.

---

## 🧱 48. Best Practices for Docker Hub

| Rule | Why |
|------|-----|
| ✅ Use meaningful tags | `v1`, `prod`, `latest`, not `test123` |
| ✅ Don’t push secrets | Never include passwords in images |
| ✅ Use `.dockerignore` | Prevents sending unnecessary files |
| ✅ Keep images small | Use `alpine` or slim versions |
| ✅ Update base images | Security patches matter |
| ✅ Use multi-stage builds | Reduces final image size |

---

## 🔄 49. Auto-Push Images in CI/CD (Example: GitHub Actions)

You can automate pushing images when code changes.

### Example Workflow (`.github/workflows/push.yml`)
```yaml
name: Push to Docker Hub
on: [push]
jobs:
  push:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v3

      - name: Login to Docker Hub
        uses: docker/login-action@v3
        with:
          username: ${{ secrets.DOCKER_USERNAME }}
          password: ${{ secrets.DOCKER_TOKEN }}

      - name: Build and push
        uses: docker/build-push-action@v5
        with:
          tags: paulco/myapp:latest
          push: true
```

> This runs on every `git push`.

---

## 🔍 50. Inspect Image from Docker Hub (Without Running)

See what’s inside an image before using it.

```bash
docker inspect nginx
```

Filter specific info:
```bash
# Show exposed ports
docker inspect nginx --format='{{.Config.ExposedPorts}}'

# Show CMD
docker inspect nginx --format='{{.Config.Cmd}}'

# Show environment variables
docker inspect nginx --format='{{.Config.Env}}'
```

---

## 🧰 51. Run One-Off Commands (Like Testing)

Run and remove container after use.

```bash
docker run --rm ubuntu echo "Hello from temp container"
```

Useful for:
- Testing commands
- Converting files
- Debugging

Example: Check curl version
```bash
docker run --rm curlimages/curl --version
```

---

## 📊 52. Monitor All Containers (Real-Time)

See CPU, memory, network usage live.

```bash
docker stats
```

Show only specific container:
```bash
docker stats webserver
```

> Press `Ctrl+C` to stop.

---

## 🧪 53. Debug a Broken Container

If a container exits immediately, check logs:

```bash
docker logs webserver
```

If no logs, run interactively:
```bash
docker run -it --rm ubuntu /bin/bash
```

Test command manually:
```bash
apt-get update
nginx -t
```

---

## 🧩 54. Use `.env` File with Docker Run

Store environment variables in `.env` file.

`.env`:
```env
DB_HOST=db.example.com
DB_PORT=5432
DB_USER=admin
DB_PASS=secret123
```

Use in run:
```bash
docker run --env-file .env ubuntu env
```

> Shows all variables set.

---

## 🧱 55. Multi-Stage Builds (Advanced Example)

Build app and run in smaller image.

```Dockerfile
# Stage 1: Build
FROM node:16 AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# Stage 2: Run
FROM nginx:alpine
COPY --from=builder /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

Build:
```bash
docker build -t paulco/static-site .
```

> Final image has **no Node.js**, only HTML + Nginx.

---

## 🔐 56. Security: Scan Images for Vulnerabilities

Scan for security issues.

```bash
docker scan nginx
```

Or for your image:
```bash
docker scan paulco/mywebapp:v1
```

> Shows CVEs (security flaws) in packages.

Fix by:
- Updating base image
- Removing unused tools
- Using distroless images

---

## 🧱 57. Use Smaller Base Images

Smaller = Faster + More Secure

| Image | Size | Use Case |
|------|------|---------|
| `alpine` | ~5MB | Lightweight Linux |
| `ubuntu:20.04` | ~70MB | Full Ubuntu |
| `node:16-alpine` | ~120MB | Node.js app |
| `node:16` | ~900MB | Development |

Prefer Alpine when possible:
```Dockerfile
FROM node:16-alpine
RUN npm install
CMD ["node", "server.js"]
```

---

## 📁 58. Bind Mount vs Volume – When to Use?

| Feature | Bind Mount | Named Volume |
|--------|------------|--------------|
| Path | `~/app:/app` | `appdata:/app` |
| Managed by | You | Docker |
| Best for | Dev (code sharing) | Prod (databases) |
| Backup | Manual | Easy |
| Portability | ❌ | ✅ |

### ✅ Use Bind Mount for Development
```bash
docker run -v $(pwd):/app node:16-alpine
```

### ✅ Use Named Volume for Production
```bash
docker volume create db-data
docker run -v db-data:/var/lib/mysql mysql
```

---

## 🧰 59. Essential Debug Commands

| Command | Purpose |
|--------|--------|
| `docker ps` | List running containers |
| `docker ps -a` | List all containers |
| `docker logs <name>` | View logs |
| `docker exec -it <name> sh` | Enter container |
| `docker inspect <name>` | See full config |
| `docker stats` | Live resource usage |
| `docker history <image>` | See image layers |
| `docker system df` | Disk usage |

---

## 🧹 60. Daily Cleanup Script (Recommended)

Save as `cleanup.sh`:
```bash
#!/bin/bash
echo "Stopping all containers..."
docker stop $(docker ps -aq)

echo "Removing all containers..."
docker rm $(docker ps -aq)

echo "Removing unused images..."
docker image prune -a -f

echo "Removing unused volumes..."
docker volume prune -f

echo "Removing unused networks..."
docker network prune -f

echo "Cleanup complete!"
```

Make executable:
```bash
chmod +x cleanup.sh
```

Run:
```bash
./cleanup.sh
```

> Great for dev machines.

---

## 🚀 61. Deploy Container on Server (Real Example)

On your **cloud server** (e.g., DigitalOcean, AWS):

```bash
# 1. Pull image from Docker Hub
docker pull paulco/mywebapp:v1

# 2. Run with port and auto-restart
docker run -d \
  --name mysite \
  -p 80:80 \
  --restart=unless-stopped \
  paulco/mywebapp:v1
```

> Site now live at: `http://your-server-ip`

---

## 🔐 62. Never Run as Root (Security)

Avoid this:
```Dockerfile
# BAD: Runs as root
CMD ["nginx"]
```

Do this:
```Dockerfile
# GOOD: Create user
RUN adduser -D appuser
USER appuser
CMD ["./start.sh"]
```

Or at runtime:
```bash
docker run --user 1000:1000 ubuntu id
```

> Prevents full system access if hacked.

---

## 📦 63. Use Scratch for Tiny Images (Advanced)

`scratch` is an empty image. Used for compiled apps (Go, Rust).

```Dockerfile
FROM golang:alpine AS builder
WORKDIR /app
COPY . .
RUN go build -o main .

# Stage 2: Use scratch
FROM scratch
COPY --from=builder /app/main /main
CMD ["/main"]
```

> Final image = only your binary. ~5MB or less.

---

## 🧭 64. Final Checklist: Production Ready?

✅ Image pushed to Docker Hub  
✅ Tagged with version (`v1`, not `latest`)  
✅ Uses non-root user  
✅ Has restart policy  
✅ Logs are accessible  
✅ Data stored in named volume  
✅ No secrets in image  
✅ Small base image (e.g., `alpine`)  
✅ Tested on clean machine  
✅ Firewall allows required ports  

---

## 🎉 Congratulations! You’ve Mastered Docker!

You now know:

- ✅ Basics: run, build, exec, logs  
- ✅ Volumes & Networks  
- ✅ Dockerfile & Docker Compose  
- ✅ Security & Best Practices  
- ✅ Docker Hub (push/pull)  
- ✅ Automation & CI/CD  
- ✅ Production deployment  

---



