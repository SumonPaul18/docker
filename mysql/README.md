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
## MySQL Error:

#### 1. mysqli::real_connect(): (HY000/1045): Access denied for user 'root'@'localhost' (using password: NO)
Reason: When Chage sql root password, after then when login phpmyadin then we are getting that error.

Solution:
https://www.youtube.com/watch?v=_gVSHeCNSRE
#### 2. Resetting MySQL Root Password with XAMPP on Localhost
Follow the following steps:

Open the XAMPP control panel and click on the shell and open the shell.

In the shell run the following:

```
mysql -h localhost -u root -p
```

and press enter. It will ask for a password, by default the password is blank so just press enter

Then just run the following query

```
SET PASSWORD FOR 'root'@'localhost' = PASSWORD('newpassword');
```

and press enter and your password is updated for root user on localhost
#
#### 3. MYSQL Container Error from Docker
```
[ERROR] [Entrypoint]: MYSQL_USER="root", MYSQL_USER and MYSQL_PASSWORD are for configuring a regular user and cannot be used for the root user
Remove MYSQL_USER="root" and use one of the following to control the root user password:
- MYSQL_ROOT_PASSWORD
- MYSQL_ALLOW_EMPTY_PASSWORD
- MYSQL_RANDOM_ROOT_PASSWORD
```
---
