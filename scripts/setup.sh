#!/bin/bash

### functions
function info() {
echo "

$1

"
}

function setup-rabbitmq() {
    VHOST=`php artisan env:get RABBITMQ_VHOST`

    rabbitmqadmin delete vhost name=$VHOST
    rabbitmqadmin declare vhost name=$VHOST

    # rabbitmqadmin declare queue --vhost=$VHOST name=
    # rabbitmqadmin declare exchange --vhost=$VHOST name= type=
    # rabbitmqadmin declare binding --vhost=$VHOST source= destination_type= destination=     
}

### constants
USER=`ls -l setup.sh | awk '{print $3}'`
FILE=.env
ENV_FILE=$FILE.example

### main
info "Hello $USER!"
info "This process will setup the application on your machine."
info "Current Database Username: $DB_USER"

if [ ! -f $FILE ]; then
    cp -p $ENV_FILE $FILE

    info "Copied: $ENV_FILE > $FILE"
    sleep 0.5
    make setup-config
fi

info "Clearing DB"
sleep 0.5
make setup-db ARGS=--drop

info "Next we have to setup rabbitmq for message queueing"
sleep 0.5
setup-rabbitmq

info "Oh! sweet script hahahahahaaaaaaaaa"
info "Restarting workers"
make restart-workers

info "Cool, done setting up our message queuing..."
info "... and it is time to add system roles"

info "> php artisan user:create-permissions"
sleep 0.5
php artisan user:create-permissions

info "> php artisan user:create-roles"
sleep 0.5
php artisan user:create-roles

info "body no be firewood... wait small make system put itself in order..."
sleep 30

info "Finally let us take a deep breath ..."
info "... and create and Administrator for our system! (press ENTER)"
read answer

info "> php artisan user:create"
php artisan user:create demo@dersure.com secret@10
