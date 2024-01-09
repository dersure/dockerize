ARG BASE_IMAGE
FROM ${BASE_IMAGE} as base

# Install supervisor
RUN apk add --update --no-cache supervisor

# Configure supervisor
ARG PHP_WORKER_PROCESS_NUMBER
ARG PHP_WORKER_COMMAND_ARGS

ENV LOG_PATH=/var/log/supervisor \
    SUPERVISOR_PORT=9001 \
    SUPERVISOR_USER_NAME=root \
    SUPERVISOR_PASSWORD=123 \
    PHP_WORKER_COMMAND="php $APP_CODE_PATH/artisan queue:work $PHP_WORKER_COMMAND_ARGS" \
    PHP_WORKER_PROCESS_NUMBER=${PHP_WORKER_PROCESS_NUMBER}

COPY ./images/php/worker/supervisor/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN mkdir ${LOG_PATH} \
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
#     sed -i "s#/dev/stdout#$LOG_FILE#" /etc/supervisor/conf.d/supervisord.conf
