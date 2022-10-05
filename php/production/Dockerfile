FROM php:fpm-alpine

RUN docker-php-ext-install opcache

COPY ./docker/php/production/php.ini /usr/local/etc/php/conf.d/php.ini
COPY ./docker/php/production/opcache.ini /usr/local/etc/php/conf.d/opcache.ini
COPY . /var/www

EXPOSE 9000
