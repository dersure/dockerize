ARG PHP_FPM_VERSION
FROM php:${PHP_FPM_VERSION}

ARG APP_CODE_PATH
ARG COMPOSER_VERSION
ARG APP_USER_ID
ARG APP_GROUP_ID
ARG APP_USER_NAME
ARG APP_GROUP_NAME

RUN addgroup -g $APP_GROUP_ID $APP_GROUP_NAME && \
    adduser -D -u $APP_USER_ID -s /bin/bash $APP_USER_NAME -G $APP_GROUP_NAME && \
    chown $APP_USER_NAME: /var/run && \
    chown $APP_USER_NAME: $APP_CODE_PATH

RUN apk add --update --no-cache \
    supervisor

RUN docker-php-ext-install pdo pdo_mysql mysqli opcache

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY queue-worker.conf /etc/supervisor/conf.d/php-worker.conf

COPY --from=composer:${COMPOSER_VERSION} /usr/bin/composer /usr/local/bin/composer

WORKDIR $APP_CODE_PATH

USER $APP_USER_NAME

EXPOSE 9000 9001

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
