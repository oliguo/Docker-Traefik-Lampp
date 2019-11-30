# Step 1

### Run update and upgrade firstly when new ubuntu[18.04] created

```
apt-get update & apt-get upgrade
```

### Add library

```
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo apt-key fingerprint 0EBFCD88

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
   
apt-get update & apt-get upgrade
```

### Install docker and others library needed

```
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose apache2-utils
```

### Start / Stop Docker

```
sudo systemctl start docker / sudo systemctl stop docker
```

### Enable the auto start service for Docker

```
sudo systemctl enable docker
```

### Restart All Container
```
docker restart $(docker ps -q)
```

# Step 2

### Download the Git files

```
https://github.com/oliguo/Docker-Traefik-Lampp-5
```

### Create the root folder for files

```
cp -r ./Docker-Traefik-Lampp-5 /opt/Docker
```

# Step 3

### Install container manager tool

```
mkdir /opt/Docker/portainer

mkdir /opt/Docker/portainer/data

docker run -d -p 9000:9000 \
 --name portainer \
 --restart always \
 -v /var/run/docker.sock:/var/run/docker.sock \
 -v /opt/Docker/portainer/data:/data \
 portainer/portainer
```

### Access the portainer by http://ip-adress:9000

# Step 4

### Install FTP individually for file upload

```
sudo apt-get install proftpd
```

### Start / Stop FTP

```
sudo systemctl start proftpd.service / sudo systemctl stop proftpd.service
```

### Enable the auto start service for FTP

```
sudo systemctl enable proftpd.service
```

### Change config

```
sudo nano /etc/proftpd/proftpd.conf
```

### Remove the '#' of lines as below

```
#PassivePorts 49152 65534
#RequireValidShell		off
```

### Add the logging under 'SystemLog   /var/log/proftpd/proftpd.log'

```
#
# Some logging formats
#
LogFormat         default "%h %l %u %t \"%r\" %s %b"
LogFormat			 auth "%v [%P] %h %t \"%r\" %s"
LogFormat			write "%h %l %u %t \"%r\" %s %b"
# You need to enable mod_logio.c to use %I and %O
LogFormat combinedio-more "%v %h %l %u %t \"%r\" %s %I %O"

# Logging
#
# file/dir access
#
ExtendedLog		/var/log/proftpd/access.log WRITE,READ combinedio-more
#
#
# Record all logins
#
ExtendedLog		/var/log/proftpd/auth.log AUTH auth
```

### Create FTP User

```
mv /opt/Docker/alpine-apache-php5 /opt/Docker/abc.com

groupadd abc.com

useradd -d /opt/Docker/abc.com/www -g abc.com -s /sbin/nologin abc.com_user

sudo chown -R abc.com_user:abc.com /opt/Docker/abc.com/www

passwd abc.com_user
```

### Add the line to proftpd.conf and restart ftp

```
#abc.com
DefaultRoot /opt/Docker/abc.com/www  abc.com
```

# Step 5

### Create network manually firstly

```
docker network create web
```

### Build Web application image

```
cd /opt/Docker/abc.com
docker build -t alpine-apache-php5 .
```

### Edit docker-compose by requirement

```
/opt/Docker/docker-compose.yml
```

### Modify traefik.toml by requirement

```toml
defaultEntryPoints = ["https","http"]
debug = false
logLevel = "INFO"
[traefikLog]
  filePath = "/opt/traefik/log/traefik.log"
  format   = "json"
[accessLog]
  filePath = "/opt/traefik/log/access.log"
  format = "json"
[file]
  directory = "/opt/traefik/rules/"
  watch = true
[entryPoints]
  [entryPoints.http]
  address = ":80"
    [entryPoints.http.redirect]
    entryPoint = "https"
  [entryPoints.https]
  address = ":443"
  [entryPoints.https.tls]
  [[entryPoints.https.tls.certificates]]
      CertFile = "/opt/traefik/certs/*.abc.com/fullchain.pem"
      KeyFile = "/opt/traefik/certs/*.abc.com/privkey.pem"
  [entryPoints.traefik]
  address = ":8080"
  [entryPoints.traefik.auth]
    [entryPoints.traefik.auth.basic]
      users = ["admin:hash_password"]

[acme]
email = "abc@abc.com"
storage = "acme.json"
entryPoint = "https"
onHostRule = true

[acme.httpChallenge]
entryPoint = "http"

[docker]
endpoint = "unix:///var/run/docker.sock"
watch = true
```

### Modify redirection rule1.toml by requirement
```toml
[backends]

[backends.abc001]
[backends.abc001.servers.server1]
url = "http://123.123.123.123:10001"
[backends.abc002]
[backends.abc002.servers.server1]
url = "http://123.123.123.123:10002" #point to https part

[frontends]

[frontends.abc001]
backend = "abc001"
passHostHeader = true
[frontends.abc001.routes.route1]
rule = "Host:abc001.abc.com"
[frontends.abc002]
backend = "abc002"
passHostHeader = true
[frontends.abc002.routes.route1]
rule = "Host:abc002.abc.com"
```

### Build and Start all applications by docker-compose

```
cd /opt/Docker
docker-compose --compatibility  up -d --force-recreate
```

