FROM alpine:latest

ARG APP_USER_ID
ARG APP_GROUP_ID
ARG APP_USER_NAME
ARG APP_GROUP_NAME

RUN addgroup -g $APP_GROUP_ID $APP_GROUP_NAME && \
    adduser -D -u $APP_USER_ID -s /bin/bash $APP_USER_NAME -G $APP_GROUP_NAME && \
    mkdir /var/log/supervisor && \
    chown $APP_USER_NAME: /var/log/supervisor && \
    chown $APP_USER_NAME: /var/run
 
RUN apk add --update --no-cache supervisor

# COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY ./supervisor/*.conf /etc/supervisor/conf.d

USER $APP_USER_NAME

EXPOSE 9001

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
