ARG BASE_IMAGE
FROM ${BASE_IMAGE} as base

# Install supervisor
RUN apk add --update --no-cache supervisor

# Configure supervisor
ARG LOG_PATH=/var/log/supervisor
ARG CONF=/etc/supervisor/conf.d/supervisord.conf
ARG SUPERVISOR_PORT=9001
ARG SUPERVISOR_USER_NAME=root
ARG SUPERVISOR_PASSWORD=123
ARG PHP_WORKER_PROCESS_NUMBER
ARG PHP_WORKER_COMMAND="php $APP_CODE_PATH/artisan queue:work"
ARG PHP_WORKER_COMMAND_ARGS

COPY ./images/php/worker/supervisor/supervisord.conf ${CONF}

RUN sed -i "s#command=__PHP_WORKER_COMMAND#command=$PHP_WORKER_COMMAND $PHP_WORKER_COMMAND_ARGS#" ${CONF} \
    && sed -i "s/numprocs=__PHP_WORKER_PROCESSES_NUMBER/numprocs=$PHP_WORKER_PROCESS_NUMBER/" ${CONF} \
    && sed -i "s#__LOG_PATH#$LOG_PATH#" ${CONF} \
    && sed -i "s/__APP_USER_NAME/$APP_USER_NAME/" ${CONF} \
    && sed -i "s/__SUPERVISOR_PORT/$SUPERVISOR_PORT/" ${CONF} \
    && sed -i "s/__SUPERVISOR_USER_NAME/$SUPERVISOR_USER_NAME/" ${CONF} \
    && sed -i "s/__SUPERVISOR_PASSWORD/$SUPERVISOR_PASSWORD/" ${CONF} \
    && mkdir ${LOG_PATH} \
    && chown $APP_USER_NAME:$APP_GROUP_NAME ${LOG_PATH} \
    && chown $APP_USER_NAME:$APP_GROUP_NAME /var/run/

# Switch to use a non-root user from here on
USER $APP_USER_NAME

# Expose the port supervisor is reachable on
EXPOSE 9001

# Let supervisord start php-worker
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

FROM base as local

# ARG LOG_FILE=$APP_CODE_PATH/storage/logs/worker.log
# RUN chown $APP_USER_NAME:$APP_GROUP_NAME ${LOG_FILE} && \
#     sed -i "s#/dev/stdout#$LOG_FILE#" ${CONF}
