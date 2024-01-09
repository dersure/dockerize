#!/bin/sh

# Exit imediately if any command or pipeline returns a non-zero exit status.
set -e

container_mode=${CONTAINER_MODE:-app}
queue_connection=${QUEUE_CONNECTION:-redis}
framework=${FRAMEWORK:-none}

echo "Container mode: $container_mode"

initialStuff() {
    echo "Framework: $framework"

    if [ ${framework}  = "laravel" ]; then
        echo "Optimize laravel application and database migration"

        # Clear cache
        # php artisan cache:clear
        # Optimizing configuration loading
        php artisan config:cache
        # Optimizing route loading
        php artisan route:cache
        # Remove this line if you do not want to run migrations on each build
        php artisan migrate --force
        # Make public files accessible from the web
        php artisan storage:link
    fi
}

if [ "$1" != "" ]; then
    exec "$@"

elif [ ${container_mode} = "app" ]; then
    initialStuff
    exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.app.conf

elif [ ${container_mode} = "worker" ]; then
    echo "Queue connection: $queue_connection"
    
    initialStuff

    if [ ${queue_connection}  = "redis" ]; then
        /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.queue.conf
    elif [ ${queue_connection}  = "rabbitmq" ]; then
        /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.rabbitmq.conf
    else
        echo "Invalid Queue connection supplied."
        exit 1
    fi

elif [ ${container_mode} = "scheduler" ]; then
    initialStuff
    /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.scheduler.conf
    # exec supercronic /etc/supercronic/laravel

else
    echo "Container mode mismatched."
    exit 1
fi
