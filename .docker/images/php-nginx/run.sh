#!/bin/sh

# Exit imediately if any command or pipeline returns a non-zero exit status.
set -e

framework=${FRAMEWORK:-laravel}

initialStuff() {
    echo "Optimizing the $framework application and database migration"

    # Clear cache
    # php artisan cache:clear

    # Optimizing configuration loading
    php artisan config:cache

    # Optimizing route loading
    php artisan route:cache

    # Remove this line if you do not want to run migrations on each build
    php artisan migrate --force
}

initialStuff

# Let supervisord start nginx & php-fpm and other processes
# exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
