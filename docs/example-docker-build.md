# Docker Setup

Build and start sample container from root

#### Build or rebuild php base with Docker Compose

`docker-compose -f .docker/compose/docker-compose-php-base.yml --env-file .docker/.env build`

`docker-compose -f .docker/compose/docker-compose-php-base-production.yml --env-file .docker/.env build`

`docker-compose -f .docker/compose/docker-compose-php-nginx.yml --env-file .docker/.env build`

#### Create and start containers
production build
`docker-compose -f .docker/compose/docker-compose.yml -p sample --env-file .docker/.env up -d`

local build
`docker-compose -f .docker/compose/docker-compose.yml -f .docker/compose/docker-compose.local.yml -p sample --env-file .docker/.env up -d`

local build with mysql and redis
`docker-compose -f .docker/compose/docker-compose.yml -f .docker/compose/docker-compose.local.mac.yml -p sample --env-file .docker/.env up -d`
