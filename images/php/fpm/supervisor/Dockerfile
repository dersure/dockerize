ARG PHP_FPM_VERSION
FROM php:${PHP_FPM_VERSION}

WORKDIR /var/www

# Install dependencies
RUN apk update && apk add --no-cache supervisor

# Install extensions
RUN docker-php-ext-install pdo pdo_mysql mysqli opcache

# Install composer
# RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

# Copy supervisor configs
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY queue-worker.conf /etc/supervisor/conf.d/php-worker.conf

# Add user for laravel application
RUN addgroup -S www
RUN adduser -S www -G www

RUN chown www:www /var/run

# Copy existing application directory permissions
COPY --chown=www:www . /var/www

# Change current user to www
USER www

# Expose port 9000 and start supervisor
EXPOSE 9000
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
