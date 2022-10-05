# Docker Setup

Clone to project directory and rename to `docker` from `dockerize`. Then copy `docker-compose.example.yml` as `docker-compose.yml` files from `docker` directory to root folder (project directory).

**Note:** If you did not rename the repo to `docker` or you changed it to another name, then you have to make changes to `docker-compose.yml` files to point to the correct path.

#### `.dockerignore`
    .git
    .env
    database.sql
    dbml-error.log
    .DS_Store
    /tests/coverage
    /docker
