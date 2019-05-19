# Docker-Traefik-Lampp-5
Building the Lampp(alpine-apache-mysql5-php5) with Traefik

## Create network manually firstly
```
docker network create web
```

## Modify traefik.toml by requirement
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

## Modify redirection rule1.toml by requirement
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

## Run docker-compose
```
docker-compose up -d --force-recreate
```
