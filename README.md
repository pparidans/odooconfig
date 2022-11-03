## Setup

```
sudo apt install docker.io docker-compose

git clone git@github.com:pparidans/odooconfig Odoo
```

Clone the repositories:
```
cd Odoo
git clone git@github.com:odoo/odoo
git clone...
```

## Build & Start

```
docker-compose up -d --scale dev=0 db
```


## Start Odoo Dev Server

```
UID=(id -u) docker-compose run --service-ports dev --database odoodb
```
