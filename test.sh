#!/bin/bash

function info() {
echo "

$1

"
}

### constants
DB_USER=`php artisan env:get DB_USERNAME`

info "Building the docker setup"
make make-init
make docker-build

info "Starting the docker setup"
make docker-down
make docker-up

info "Clearing DB"
sleep 0.5
php artisan env:set DB_USERNAME root
make setup-db ARGS="profile --drop"
php artisan env:set DB_USERNAME $DB_USER

info "Stopping workers"
make stop-workers

info "Clearing RabbitMQ"
sleep 0.5
sh setup-rabbitmq.sh

# info "Ensuring that queue and db are empty"
# curl -sS "http://127.0.0.1/?queue"
# curl -sS "http://127.0.0.1/?db"

# info "Dispatching a job 'ping'"
# php artisan ping:job

# info "Asserting the job 'foo' is on the queue"
# curl -sS "http://127.0.0.1/?queue"

# info "Starting the workers"
# make start-workers
# sleep 1

# info "Asserting the queue is now empty"
# curl -sS "http://127.0.0.1/?queue"

# info "Asserting the db now contains the job 'foo'"
# curl -sS "http://127.0.0.1/?db"
