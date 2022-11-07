## Setup

Install Docker:
```
sudo apt install docker.io docker-compose
```

Give your user the Docker rights:
```
sudo usermod -aG docker $USER
```

Clone this repository:
```
git clone git@github.com:pparidans/odooconfig
```

## Build & Start

```
mkdir -p /var/tmp/odoo

docker-compose up -d --scale dev=0 db
```


## Start Odoo Dev Server

```
UID=(id -u) docker-compose run --service-ports dev --database odoodb
```
