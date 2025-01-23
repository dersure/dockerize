ARG BASE_IMAGE
FROM ${BASE_IMAGE} as base

# Install php-fpm
RUN echo "php${PHP_VERSION}"
RUN apk add --no-cache --update php$PHP_VERSION-fpm

# Configure php-fpm
COPY ./images/php/fpm/php-fpm.d/ /etc/php${PHP_VERSION}/php-fpm.d/
COPY ./images/php/fpm/conf.d/app-fpm.ini /etc/php${PHP_VERSION}/conf.d/
RUN sed -i "s/__APP_USER_NAME/$APP_USER_NAME/" /etc/php${PHP_VERSION}/php-fpm.d/* \
    && sed -i "s/__APP_GROUP_NAME/$APP_GROUP_NAME/" /etc/php${PHP_VERSION}/php-fpm.d/*

# Create symlink for php-fpm
RUN ln -s /usr/sbin/php-fpm${PHP_VERSION} /usr/bin/php-fpm

# Switch to use a non-root user from here on
USER $APP_USER_NAME

# Expose the port php-fpm is reachable on
EXPOSE 9000

# Start php-fpm
CMD ["php-fpm", "-F"]

FROM base as local

COPY ./images/php/fpm/conf.d/${ENV}/* /etc/php${PHP_VERSION}/conf.d/

FROM base as production
