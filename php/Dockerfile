ARG PHP_FPM_VERSION
FROM php:${PHP_FPM_VERSION}

WORKDIR /var/www

# Install dependencies
# RUN apt-get update && apt-get install -y \
    # build-essential

# Clear cache
# RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install extensions
RUN docker-php-ext-install pdo pdo_mysql mysqli opcache

# Install composer
# RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

# Add user for laravel application
RUN addgroup -S www
RUN adduser -S www -G www

# Copy existing application directory permissions
COPY --chown=www:www . /var/www

# Change current user to www
USER www

# Expose port 9000 and start php-fpm server
EXPOSE 9000
CMD ["php-fpm"]
