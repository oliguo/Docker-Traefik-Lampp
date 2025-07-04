# Step 1

### Run update and upgrade firstly when new ubuntu[24.04] created

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

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
   
apt-get update & apt-get upgrade
```

### Install docker and others library needed

```
sudo apt-get install docker-ce docker-ce-cli containerd.io apache2-utils
```

### Install docker compose

```
DOCKER_CONFIG=${DOCKER_CONFIG:-$HOME/.docker}
mkdir -p $DOCKER_CONFIG/cli-plugins
curl -SL https://github.com/docker/compose/releases/download/v2.36.0/docker compose-linux-x86_64 -o $DOCKER_CONFIG/cli-plugins/docker compose
sudo chmod +x $DOCKER_CONFIG/cli-plugins/docker compose
docker compose version
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
https://github.com/oliguo/Docker-Traefik-Lampp
```

### Create the root folder for files

```
cp -r ./Docker-Traefik-Lampp /opt/docker
```

# Step 3

### Install container manager tool

```
mkdir -pv /opt/docker/portainer/data

docker run -d -p 9000:9000 \
 --name portainer \
 --restart always \
 -v /var/run/docker.sock:/var/run/docker.sock \
 -v /opt/docker/portainer/data:/data \
 portainer/portainer
```

### Access the portainer by http://ip-adress:9000

# Step 4

### Install FTP individually for file upload

```
sudo apt-get install proftpd proftpd-basic
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

### Create FTP User and restart Proftpd

```
sudo mkdir -pv /opt/docker/apps
sudo mv /opt/docker/alpine-apache-php5 /opt/docker/apps/abc.com
    or
sudo mv /opt/docker/alpine-apache-php7 /opt/docker/apps/abc.com

sudo groupadd abc_com_group
sudo useradd -d /opt/docker/apps/abc.com/www -g abc_com_group -s /sbin/nologin abc_com
sudo chown -Rv abc_com:abc_com_group /opt/docker/apps/abc.com/www

cat /etc/passwd | grep 'abc_com*'

sudo ftpasswd  --passwd --file=/usr/local/proftpd/ftpd.passwd --name=abc_com  --uid=1000 --gid=1000  --home=/opt/docker/apps/abc.com/www  --shell=/sbin/nologin

sudo vim /etc/proftpd/conf.d/settings.conf
    DefaultRoot /opt/docker/apps/abc.com/www abc_com_group
    <Directory "/opt/docker/apps/abc.com/www">
        <Limit CWD MKD RNFR READ WRITE STOR RETR>
            DenyAll
        </Limit>
        <Limit CWD MKD RNFR READ WRITE STOR RETR>
            AllowUser abc_com
        </Limit>
    </Directory>
  
sudo systemctl restart proftpd.service
```


# Step 5

### Create network manually firstly

```
docker network create web
```

### Build Web application image

```
cd /opt/docker/abc.com
docker build -t alpine-apache-php5 .
or
docker build -t alpine-apache-php7 .
or
docker build -t alpine-apache-php8 .

```

### Edit docker compose by requirement

```
#traefik v1 version
/opt/docker/docker compose.yml
Or
#traefik V3 version
/opt/docker/docker compose.traefik2.yml
#traefik v3 version
/opt/docker/docker compose.traefik3.yml
```

## Traefik V1

#### Modify traefik.toml by requirement

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

#### Set password for traefik(v1.7.11) dashbard and update it on the traefik.tml

```
echo $(htpasswd -nb admin 123456)
```

```
[entryPoints.traefik.auth]
    [entryPoints.traefik.auth.basic]
      users = ["admin:xxxx"]
```

#### Modify redirection rule1.toml by requirement

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

#### Build and Start all applications by docker compose

```
sudo chmod 600 /opt/docker/traefik/acme.json
cd /opt/docker
docker compose --compatibility  up -d --force-recreate
```

## Traefik V3

#### Modify traefik.toml by requirement

```yml
providers:
  docker: {}

log:
  filePath: "/opt/traefik/logs/traefik.log"
  format: json
  level: INFO

# Configuring a buffer of 100 lines
accessLog:
  filePath: "/opt/traefik/logs/access.log"
  format: json
  bufferingSize: 100

api:
  # Dashboard
  #
  # Optional
  # Default: true
  #
  dashboard: true
  #insecure: true

entryPoints:
  web:
    address: ":80"
    #http:
    #  redirections:
    #    entryPoint:
    #      to: websecure
    #      scheme: https

  websecure:
    address: ":443"

certificatesResolvers:
  webResolver:
    acme:
      email: abc@abc.com
      storage: /letsencrypt/acme.json
      httpChallenge:
        # used during the challenge
        entryPoint: web
```

#### Set password for traefik(V3) dashbard and update it on the docker compose.traefik2.yml

```
echo $(htpasswd -nb admin 123456)
```

```yml
 - "traefik.http.middlewares.traefik2_auth.basicauth.users=admin:xxx"
```

#### Build and Start all applications by docker compose

```
cd /opt/docker
docker compose -f docker compose.traefik2.yml --compatibility  up -d --force-recreate
```

# Change mysql root password

```
SET PASSWORD FOR 'root' = PASSWORD('your password');

ALTER USER 'root'@'localhost' IDENTIFIED BY 'your password';
```


# Logging by crontab

```
crontab -e

##clear traefik log and restart traefik
0 0 * * 0 rm /where is path/traefik/log/*
5 0 * * 0 docker restart traefik

##logging the stats per 30mins
*/30 * * * * docker stats -a --no-stream >> /log folder you created/docker-stats-log/`date +\%Y\%m\%d\%H\%M\%S`.csv
*/30 * * * * ps auxf > /log folder you created/htop-log/`date +\%Y\%m\%d\%H\%M\%S`.csv

##clear log every sunday
0 0 * * 0 rm /log folder you created/docker-stats-log/`date +\%Y\%m`*.csv
0 0 * * 0 rm /log folder you created/htop-log/`date +\%Y\%m`*.csv

##clear access log last month 
59 23 1 * * * rm /opt/docker/abc.com/log/apache2/access_log.`date --date="$(date +\%m) -1 month" +\%Y-\%m*`
59 23 1 * * * rm /opt/docker/abc.com/log/apache2/ssl_access_log.`date --date="$(date +\%m) -1 month" +\%Y-\%m*`
```
