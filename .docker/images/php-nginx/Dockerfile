ARG BASE_IMAGE=dersure/php-base:latest
FROM ${BASE_IMAGE} as base

LABEL maintainer="Dersure Limited <dev0@dersureltd.com>"

# Accepted values: redis - rabbitmq
ARG FRAMEWORK="laravel"

# Accepted values: redis - rabbitmq
ARG QUEUE_CONNECTION="redis"

# Accepted values: app - worker - scheduler
ARG CONTAINER_MODE=app

ARG APP_WITH_QUEUE=false
ARG APP_WITH_RABBITMQ=false
ARG APP_WITH_SCHEDULER=false

ENV CONTAINER_MODE=${CONTAINER_MODE} \
    APP_WITH_QUEUE=${APP_WITH_QUEUE} \
    APP_WITH_RABBITMQ=${APP_WITH_RABBITMQ} \
    APP_WITH_SCHEDULER=${APP_WITH_SCHEDULER} \
    FRAMEWORK=${FRAMEWORK} \
    QUEUE_CONNECTION=${QUEUE_CONNECTION}

# Install packages
RUN apk add --no-cache --update \
    nginx \
    php$PHP_VERSION-fpm \
    supervisor

# Configure nginx - http
COPY ./images/php-nginx/config/nginx.conf /etc/nginx/nginx.conf

# Configure nginx - default server
ARG NGINX_ROOT=$APP_CODE_PATH
COPY ./images/php-nginx/config/conf.d/default.conf /etc/nginx/conf.d/
RUN sed -i "s#root __NGINX_ROOT;#root $NGINX_ROOT;#" /etc/nginx/conf.d/default.conf

# Configure php-fpm
COPY ./images/php/fpm/php-fpm.d/ /etc/php${PHP_VERSION}/php-fpm.d/
COPY ./images/php/fpm/conf.d/app-fpm.ini /etc/php${PHP_VERSION}/conf.d/
RUN sed -i "s/__APP_USER_NAME/$APP_USER_NAME/" /etc/php${PHP_VERSION}/php-fpm.d/* \
    && sed -i "s/__APP_GROUP_NAME/$APP_GROUP_NAME/" /etc/php${PHP_VERSION}/php-fpm.d/*

###########################################
# Configure supervisor
###########################################

ARG PHP_WORKER_PROCESS_NUMBER=2

ENV LOG_PATH=/var/log/supervisor \
    SUPERVISOR_PORT=9001 \
    SUPERVISOR_USER_NAME=root \
    SUPERVISOR_PASSWORD=123 \
    PHP_WORKER_PROCESS_NUMBER=${PHP_WORKER_PROCESS_NUMBER}

COPY ./images/php-nginx/config/supervisord* /etc/supervisor/conf.d/

# Create directory for custom supervisord configuration
RUN mkdir /etc/supervisor/conf.d/deployment

RUN mkdir ${LOG_PATH} \
    && chown $APP_USER_NAME:$APP_GROUP_NAME ${LOG_PATH} \
    && chown $APP_USER_NAME:$APP_GROUP_NAME /var/run/

###########################################

###########################################
# Laravel scheduler
###########################################

# RUN if [ ${CONTAINER_MODE} = 'scheduler' ] || [ ${APP_WITH_SCHEDULER} = true ]; then \
#   wget -q "https://github.com/aptible/supercronic/releases/download/v0.2.26/supercronic-linux-amd64" \
#   -O /usr/bin/supercronic \
#   && chmod +x /usr/bin/supercronic \
#   && mkdir -p /etc/supercronic \
#   && echo "*/1 * * * * php ${APP_CODE_PATH}/artisan schedule:run --verbose --no-interaction" > /etc/supercronic/laravel; \
# fi

###########################################

# Include executable
COPY ./images/php-nginx/run.sh /usr/bin/start-container
RUN chmod +x /usr/bin/start-container

# Make sure files/folders needed by the processes are accessable when they run under the nobody user
RUN chown -R $APP_USER_NAME.$APP_GROUP_NAME $APP_CODE_PATH /run /var/lib/nginx /var/log/nginx

# Switch to use a non-root user from here on
USER $APP_USER_NAME

# Expose the port nginx is reachable on
EXPOSE 80 443

ENTRYPOINT ["/usr/bin/start-container"]

# Let supervisord start nginx & php-fpm
# CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

# Configure a healthcheck to validate that everything is up & running
HEALTHCHECK --timeout=10s CMD curl --silent --fail http://127.0.0.1:80/fpm-ping

FROM base as local
COPY ./logs/nginx/ /var/log/nginx/
COPY ./images/php/fpm/conf.d/${ENV}/* /etc/php${PHP_VERSION}/conf.d/

FROM base as production
COPY ./images/nginx/ssl/ /etc/nginx/ssl/
