# Docker Setup

Clone to project directory: `git clone https://github.com/dersure/dockerize.git docker`.

### Docker Compose

#### Build or rebuild php base

`docker build -f docker/images/php/base/Dockerfile -t local/php-base .`

`docker-compose -f docker/compose/docker-compose-php-base.yml --env-file docker/.env build`

#### Create and start containers
production build
`docker-compose -f docker/compose/docker-compose.yml -p project-name --env-file docker/.env up -d`

local build
`docker-compose -f docker/compose/docker-compose.yml -f docker/compose/docker-compose.local.yml -p project-name --env-file docker/.env up -d`

#### `.dockerignore`
    .git
    .env
    database.sql
    dbml-error.log
    .DS_Store
    /tests/coverage
    /docker

### Expose events to hook into Containers

- Files from `/etc/supervisor/conf.d/deployment/` will be loaded from `/etc/supervisor/conf.d/supervisord.app.conf`.

- We can also make use of `/opt/docker/provision/entrypoint.d/` to include other configuration event like `bash` script to optimize laravel application.
