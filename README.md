## Setup

```
sudo apt install docker.io docker-compose

git clone git@github.com:pparidans/odooconfig Odoo

cd Odoo
git clone git@github.com:odoo/odoo
...

```

## Build & Start

```
docker-compose up -d --scale odoo-dev=0 odoo-db
```


## Start Odoo Dev Server

```
UID=(id -u) docker-compose run --service-ports odoo-dev --database odoodb
```
