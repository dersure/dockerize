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
    # mkdir -p $APP_CODE_PATH && \
    chown $APP_USER_NAME: $APP_CODE_PATH

# Install extensions
RUN docker-php-ext-install pdo pdo_mysql mysqli opcache

# Install composer
COPY --from=composer:${COMPOSER_VERSION} /usr/bin/composer /usr/local/bin/composer

WORKDIR $APP_CODE_PATH

# Change current user to www
USER $APP_USER_NAME

# Expose port 9000 and start php-fpm server
EXPOSE 9000
CMD ["php-fpm"]
