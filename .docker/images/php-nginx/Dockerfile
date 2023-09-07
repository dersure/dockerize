ARG BASE_IMAGE
FROM ${BASE_IMAGE} as base

# Install packages
RUN apk add --no-cache --update \
    nginx \
    php$PHP_VERSION-fpm \
    supervisor

# Configure nginx - http
COPY ./images/php-nginx/nginx.conf /etc/nginx/nginx.conf

# Configure nginx - default server
ARG NGINX_ROOT=$APP_CODE_PATH
COPY ./images/php-nginx/conf.d/default.conf /etc/nginx/conf.d/
RUN sed -i "s#root __NGINX_ROOT;#root $NGINX_ROOT;#" /etc/nginx/conf.d/default.conf

# Configure php-fpm
COPY ./images/php/fpm/php-fpm.d/ /etc/php${PHP_VERSION}/php-fpm.d/
COPY ./images/php/fpm/conf.d/app-fpm.ini /etc/php${PHP_VERSION}/conf.d/
RUN sed -i "s/__APP_USER_NAME/$APP_USER_NAME/" /etc/php${PHP_VERSION}/php-fpm.d/* \
    && sed -i "s/__APP_GROUP_NAME/$APP_GROUP_NAME/" /etc/php${PHP_VERSION}/php-fpm.d/*

# Configure supervisor/worker
ARG SUPERVISOR_LOG=/var/log/supervisor
ARG SUPERVISOR_PORT=9001
ARG SUPERVISOR_USER_NAME=root
ARG SUPERVISOR_PASSWORD=123
COPY ./images/php-nginx/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
RUN sed -i "s#__SUPERVISOR_LOG#$SUPERVISOR_LOG#" /etc/supervisor/conf.d/supervisord.conf \
    && sed -i "s/__APP_USER_NAME/$APP_USER_NAME/" /etc/supervisor/conf.d/supervisord.conf \
    && sed -i "s/__SUPERVISOR_PORT/$SUPERVISOR_PORT/" /etc/supervisor/conf.d/supervisord.conf \
    && sed -i "s/__SUPERVISOR_USER_NAME/$SUPERVISOR_USER_NAME/" /etc/supervisor/conf.d/supervisord.conf \
    && sed -i "s/__SUPERVISOR_PASSWORD/$SUPERVISOR_PASSWORD/" /etc/supervisor/conf.d/supervisord.conf \
    && mkdir ${SUPERVISOR_LOG} \
    && chown $APP_USER_NAME:$APP_GROUP_NAME ${SUPERVISOR_LOG} \
    && chown $APP_USER_NAME:$APP_GROUP_NAME /var/run/

# Make sure files/folders needed by the processes are accessable when they run under the nobody user
RUN chown -R $APP_USER_NAME.$APP_GROUP_NAME $APP_CODE_PATH /run /var/lib/nginx /var/log/nginx

# Switch to use a non-root user from here on
USER $APP_USER_NAME

# Expose the port nginx is reachable on
EXPOSE 80

# Let supervisord start nginx & php-fpm
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

# Configure a healthcheck to validate that everything is up&running
HEALTHCHECK --timeout=10s CMD curl --silent --fail http://127.0.0.1:80/fpm-ping

FROM base as local
COPY ./logs/nginx/ /var/log/nginx/
COPY ./images/php/fpm/conf.d/${ENV}/* /etc/php${PHP_VERSION}/conf.d/

FROM base as production
COPY ./images/nginx/ssl/ /etc/nginx/ssl/
