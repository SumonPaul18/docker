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

---
### Resetting MySQL Root Password with XAMPP on Localhost
Follow the following steps:

Open the XAMPP control panel and click on the shell and open the shell.

In the shell run the following:

```mysql -h localhost -u root -p```
and press enter. It will ask for a password, by default the password is blank so just press enter

Then just run the following query

```SET PASSWORD FOR 'root'@'localhost' = PASSWORD('newpassword'); ```
and press enter and your password is updated for root user on localhost
