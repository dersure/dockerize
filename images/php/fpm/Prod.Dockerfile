FROM php:fpm-alpine

RUN docker-php-ext-install opcache

ARG APP_CODE_PATH

COPY ./conf/local.ini /usr/local/etc/php/conf.d/php.ini
COPY ./conf/opcache.ini /usr/local/etc/php/conf.d/opcache.ini
COPY . $APP_CODE_PATH

EXPOSE 9000
