ARG BASE_IMAGE
FROM ${BASE_IMAGE} as base

RUN echo ${PHP_VERSION}
RUN apk add --no-cache --update php-fpm~=$PHP_VERSION && ln -s /usr/sbin/php-fpm8 /usr/bin/php-fpm

COPY ./images/php/fpm/php-fpm.d/ /etc/php8/php-fpm.d/
COPY ./images/php/fpm/conf.d/${ENV}/* /etc/php8/conf.d/
COPY ./images/php/fpm/conf.d/app-fpm.ini /etc/php8/conf.d/

RUN sed -i "s/__APP_USER_NAME/$APP_USER_NAME/" /etc/php8/php-fpm.d/* \
    && sed -i "s/__APP_GROUP_NAME/$APP_GROUP_NAME/" /etc/php8/php-fpm.d/*

RUN apk add --update --no-cache \
    supervisor

COPY ./images/php/fpm/supervisor/conf.d/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

ARG SUPERVISOR_PORT=9001
ARG SUPERVISOR_USER_NAME=root
ARG SUPERVISOR_PASSWORD=123
ARG PHP_WORKER_PROCESS_NUMBER
ARG PHP_WORKER_COMMAND="php $APP_CODE_PATH/artisan queue:work"
ARG PHP_WORKER_COMMAND_ARGS

RUN sed -i "s#command=__PHP_WORKER_COMMAND#command=$PHP_WORKER_COMMAND $PHP_WORKER_COMMAND_ARGS#" /etc/supervisor/conf.d/supervisord.conf \
    && sed -i "s/numprocs=__PHP_WORKER_PROCESSES_NUMBER/numprocs=$PHP_WORKER_PROCESS_NUMBER/" /etc/supervisor/conf.d/supervisord.conf \
    && sed -i "s/__APP_USER_NAME/$APP_USER_NAME/" /etc/supervisor/conf.d/supervisord.conf \
    && sed -i "s/__SUPERVISOR_PORT/$SUPERVISOR_PORT/" /etc/supervisor/conf.d/supervisord.conf \
    && sed -i "s/__SUPERVISOR_USER_NAME/$SUPERVISOR_USER_NAME/" /etc/supervisor/conf.d/supervisord.conf \
    && sed -i "s/__SUPERVISOR_PASSWORD/$SUPERVISOR_PASSWORD/" /etc/supervisor/conf.d/supervisord.conf \
    && chown $APP_USER_NAME:$APP_GROUP_NAME /var/run/

USER $APP_USER_NAME

EXPOSE 9000 9001

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

FROM base as local

RUN sed -i "s#logfile=/dev/null#logfile=$APP_CODE_PATH/storage/logs/supervisord.log#" /etc/supervisor/conf.d/supervisord.conf \
    && sed -i "s#/dev/stdout#$APP_CODE_PATH/storage/logs/worker.log#" /etc/supervisor/conf.d/supervisord.conf
