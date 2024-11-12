# Run MySQL & phpAdmin in Docker

#### Clone this Repository:
```
git clone https://github.com/SumonPaul18/docker.git
cd docker/mysql
docker compose up -d
```
#### Verifying the mysql & phpAdmin Container
```
docker compose ps
```
```
docker ps
```
#### Access mysql terminal inside Container
```
docker exec -it 
```
#### Access phpAdmin from Browser
```
http://docker-host-ip:phpadmin-port
```
input your defined user & password
