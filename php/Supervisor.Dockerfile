ARG PHP_FPM_VERSION
FROM php:${PHP_FPM_VERSION}

WORKDIR /var/www

# Install dependencies
RUN apt-get update && apt-get install -y supervisor

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install extensions
RUN docker-php-ext-install pdo pdo_mysql mysqli opcache

# Install composer
# RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

# Copy supervisor configs
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Add user for laravel application
RUN groupadd -g 1000 www
RUN useradd -u 1000 -ms /bin/bash -g www www

# Copy existing application directory permissions
COPY --chown=www:www . /var/www

# Change current user to www
USER www

# Expose port 9000 and start supervisor
EXPOSE 9000
CMD ["/usr/bin/supervisord"]
