ARG BASE_IMAGE
FROM ${BASE_IMAGE} as base

RUN apk add --update --no-cache supervisor

COPY ./images/supervisor/conf.d/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

ARG SUPERVISOR_LOG=/var/log/supervisor
ARG SUPERVISOR_PORT=9001
ARG SUPERVISOR_USER_NAME=root
ARG SUPERVISOR_PASSWORD=123

RUN sed -i "s#__SUPERVISOR_LOG#$SUPERVISOR_LOG#" /etc/supervisor/conf.d/supervisord.conf \
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

FROM base as production
