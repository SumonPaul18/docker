# 🔐 Docker Container Advanced Configuration: SSH Access Guide  
*(From Beginner to Advanced – Step-by-Step)*

> SSH into Docker containers is useful for **debugging** and **development**, but **not recommended for production**. Use `docker exec` instead in production.

---

## 🐳 1. Why You Might Want SSH in a Docker Container

### ✅ Use Cases
- Debugging a running container
- Learning Linux inside a safe environment
- Testing SSH-based scripts
- Legacy app that requires SSH

### ❌ Don’t Use in Production
- Adds attack surface
- Goes against Docker’s philosophy (one process per container)
- Better alternatives: `docker exec`, logging, monitoring

---

## ⚠️ 2. Common Error: `Failed to get D-Bus connection: Operation not permitted`

### ❌ Problem
You try to run `systemctl` or `service sshd restart` inside a container and get:

```text
Failed to get D-Bus connection: Operation not permitted
```

### ✅ Why It Happens
Docker containers **don’t run a full init system** by default. So `systemctl`, `service`, and `systemd` don’t work.

---

## 🛠️ 3. Fix: Run Container with Full Init System (CentOS/RHEL)

To use `systemctl`, start the container with `/usr/sbin/init`.

```bash
docker run -d \
  --name centos7 \
  --privileged \
  centos:7 \
  /usr/sbin/init
```

> - `--privileged`: Gives full access to host devices  
> - `/usr/sbin/init`: Starts systemd inside container

---

## 🔐 4. Enable SSH in CentOS Container

Now enter and configure SSH:

```bash
docker exec -it centos7 /bin/bash
```

Inside container:

```bash
# Install OpenSSH server
yum install -y openssh-server

# Set root password
echo 'root:centos' | chpasswd

# Allow root login
sed -i 's/#PermitRootLogin yes/PermitRootLogin yes/' /etc/ssh/sshd_config
sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# Start SSH service
systemctl start sshd
systemctl enable sshd

# Check status
systemctl status sshd
```

---

## 🌐 5. Get Container IP Address

```bash
docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' centos7
```

> Output: `172.17.0.2`

---

## 🔐 6. SSH into CentOS Container

From your **host machine**:

```bash
ssh root@172.17.0.2
```

> Enter password: `centos`

✅ You’re now inside the container via SSH.

---

## 🧱 7. Build Ubuntu Container with SSH (Dockerfile)

Create a custom image with SSH pre-configured.

```bash
mkdir ssh-container && cd ssh-container
nano Dockerfile
```

Paste this:

```Dockerfile
FROM ubuntu:20.04

# Update and install OpenSSH server
RUN apt-get update && \
    apt-get install -y openssh-server && \
    mkdir -p /var/run/sshd

# Set root password (change 'ubuntu' to your password)
RUN echo 'root:ubuntu' | chpasswd

# Allow root login via SSH
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# Fix PAM issue (prevents login failure)
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

# Expose SSH port
EXPOSE 22

# Start SSH daemon
CMD ["/usr/sbin/sshd", "-D"]
```

> 🔐 Note: Avoid hardcoding passwords in production.

---

## 🛠️ 8. Build the SSH Image

```bash
docker build -t ssh-ubuntu .
```

> This creates an image named `ssh-ubuntu`.

---

## ▶️ 9. Run the SSH Container

```bash
docker run -d -P --name myssh ssh-ubuntu
```

> - `-d`: Run in background  
> - `-P`: Publish all exposed ports (SSH on 22 → random host port)

---

## 🔍 10. Find SSH Port on Host

```bash
docker port myssh 22
```

> Output: `0.0.0.0:32768`

So SSH is available on **host port 32768**.

---

## 🌐 11. Get Container IP (Optional)

```bash
docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' myssh
```

> Output: `172.17.0.3`

---

## 🔐 12. SSH into Ubuntu Container

From host:

```bash
ssh root@localhost -p 32768
```

> Password: `ubuntu`

✅ Login successful.

---

## 🔧 13. Fix: Can’t SSH? Debug Steps

If SSH fails:

### 1. Check if container is running
```bash
docker ps
```

### 2. Check logs
```bash
docker logs myssh
```

Look for:
- `sshd` not starting
- Permission denied
- Port already in use

### 3. Enter container directly
```bash
docker exec -it myssh /bin/bash
```

Check:
```bash
ps aux | grep sshd
systemctl status sshd  # Only works if systemd is running
```

---

## 🔐 14. Security: Never Use Root SSH in Production

### ✅ Better Approach
Instead of SSH, use:

```bash
docker exec -it myapp /bin/bash
```

It’s **faster**, **safer**, and **doesn’t require password setup**.

---

## 🔐 15. Secure SSH: Use Non-Root User (Advanced)

Update Dockerfile:

```Dockerfile
FROM ubuntu:20.04

RUN apt-get update && \
    apt-get install -y openssh-server && \
    mkdir -p /var/run/sshd

# Create a user
RUN useradd -m myuser && \
    echo 'myuser:password' | chpasswd && \
    adduser myuser sudo

# Allow password login
RUN sed -i 's/#PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config && \
    sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config

# Fix PAM
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
```

Build and run:
```bash
docker build -t ssh-safe .
docker run -d -P --name ssh-safe-container ssh-safe
```

SSH as user:
```bash
ssh myuser@localhost -p [mapped-port]
```

> Password: `password`

---

## 🔑 16. Best Practice: Use SSH Keys (No Password)

### 1. Generate SSH Key (on host)
```bash
ssh-keygen -t rsa -b 2048 -f ~/.ssh/docker-key
```

### 2. Update Dockerfile

```Dockerfile
FROM ubuntu:20.04

RUN apt-get update && \
    apt-get install -y openssh-server && \
    mkdir -p /root/.ssh /var/run/sshd

# Add your public key
COPY id_rsa.pub /root/.ssh/authorized_keys

RUN chmod 700 /root/.ssh && \
    chmod 600 /root/.ssh/authorized_keys && \
    chown -R root:root /root/.ssh

# Enable SSH login with key
RUN sed -i 's/#PermitRootLogin yes/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
```

### 3. Build & Run
```bash
docker build -t ssh-key .
docker run -d -P --name ssh-key-container ssh-key
```

### 4. SSH with Key
```bash
ssh -i ~/.ssh/docker-key root@localhost -p [mapped-port]
```

✅ No password needed. More secure.

---

## 🧰 17. Useful Commands for SSH Containers

| Command | Purpose |
|--------|--------|
| `docker logs myssh` | See SSH startup errors |
| `docker exec -it myssh ps aux` | Check if `sshd` is running |
| `docker port myssh 22` | Find mapped SSH port |
| `docker inspect myssh` | View full container config |
| `docker stop myssh` | Stop container |
| `docker rm myssh` | Remove container |

---

## 🧹 18. Cleanup SSH Containers

```bash
docker stop myssh
docker rm myssh
docker rmi ssh-ubuntu
```

Or remove all stopped containers:
```bash
docker container prune
```

---

## 🧩 19. Alternative: Use `docker exec` Instead of SSH

✅ **Recommended for daily use**

```bash
# Enter container
docker exec -it myapp /bin/bash

# Run a command
docker exec myapp ls /var/log

# Run as specific user
docker exec -it -u myuser myapp /bin/bash
```

> No SSH setup needed. Safer. Faster.

---

## 📦 20. When You Must Use SSH: Development Only

Use SSH only if:
- You’re training new developers
- You’re testing automation scripts
- You’re debugging a broken container
- You need remote access from another machine

---

## ✅ Final Checklist: SSH in Docker

| Step | Done? |
|------|------|
| ✅ Use only for dev/testing | ☐ |
| ✅ Avoid root login in production | ☐ |
| ✅ Use SSH keys instead of passwords | ☐ |
| ✅ Use `docker exec` when possible | ☐ |
| ✅ Remove container after use | ☐ |
| ✅ Never expose SSH to public internet | ☐ |

---

## 🎉 Congratulations!

You now know how to:

- ✅ Fix `Failed to get D-Bus connection` error
- ✅ Run systemd in CentOS containers
- ✅ Build Ubuntu container with SSH
- ✅ SSH into both Ubuntu and CentOS
- ✅ Use non-root users and SSH keys
- ✅ Secure your SSH containers
- ✅ Know when **not** to use SSH

---

## 💾 Save This File As:
```
Docker-SSH-Guide.md
```

Keep it for:
- Learning
- Debugging
- Teaching others

---

## 🐳 Happy Dockering!

Remember:  
> **`docker exec` > SSH**  
> Use SSH only when absolutely necessary.

But now you know **how to do it safely and correctly**.
