ARG BASE_IMAGE
FROM ${BASE_IMAGE} as base

RUN apk add --update --no-cache supervisor

COPY ./images/php/worker/supervisor/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

ARG SUPERVISOR_LOG=/var/log/supervisor
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
    && mkdir ${SUPERVISOR_LOG} \
    && chown $APP_USER_NAME:$APP_GROUP_NAME ${SUPERVISOR_LOG} \
    && chown $APP_USER_NAME:$APP_GROUP_NAME /var/run/

USER $APP_USER_NAME

EXPOSE 9001

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

FROM base as local

ARG LOG_FILE=$APP_CODE_PATH/storage/logs/worker.log
RUN chown $APP_USER_NAME:$APP_GROUP_NAME ${LOG_FILE} && \
    sed -i "s#/dev/stdout#$LOG_FILE#" /etc/supervisor/conf.d/supervisord.conf
