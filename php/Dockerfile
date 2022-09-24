ARG PHP_FPM_VERSION
FROM php:${PHP_FPM_VERSION}

WORKDIR /var/www

RUN docker-php-ext-install pdo pdo_mysql mysqli opcache

COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer
