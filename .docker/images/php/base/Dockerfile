ARG ALPINE_VERSION=3.18
FROM alpine:${ALPINE_VERSION} as base

# make build args available as ENV variables to downstream images
# so that we don't have to pass the same build args again
ARG APP_USER_ID
ARG APP_GROUP_ID
ARG APP_USER_NAME
ARG APP_GROUP_NAME
ARG APP_CODE_PATH
ARG PHP_VERSION
ARG ALPINE_VERSION
ARG ENV

ENV APP_USER_ID=${APP_USER_ID}
ENV APP_GROUP_ID=${APP_GROUP_ID}
ENV APP_USER_NAME=${APP_USER_NAME}
ENV APP_GROUP_NAME=${APP_GROUP_NAME}
ENV APP_CODE_PATH=${APP_CODE_PATH}
ENV PHP_VERSION=${PHP_VERSION}
ENV ALPINE_VERSION=${ALPINE_VERSION}
ENV ENV=${ENV}

RUN addgroup -g $APP_GROUP_ID $APP_GROUP_NAME && \
    adduser -D -u $APP_USER_ID -s /bin/bash $APP_USER_NAME -G $APP_GROUP_NAME && \
    mkdir -p $APP_CODE_PATH && \
    chown $APP_USER_NAME: $APP_CODE_PATH

RUN apk add --update --no-cache \
        make
        # bash \
        # strace \
        # sudo \
        # vim

# install packages/PHP
RUN apk --update-cache add ca-certificates && \
    echo "php${PHP_VERSION}" && \
    apk add --update --no-cache  \
        php${PHP_VERSION} \
        php${PHP_VERSION}-curl \
        php${PHP_VERSION}-dom \
        php${PHP_VERSION}-mbstring \
        php${PHP_VERSION}-mysqli \
        php${PHP_VERSION}-pdo_mysql \
        php${PHP_VERSION}-pdo \
        php${PHP_VERSION}-phar \
        php${PHP_VERSION}-redis \
        php${PHP_VERSION}-sockets \
        php${PHP_VERSION}-tokenizer \
        php${PHP_VERSION}-xml \
        php${PHP_VERSION}-zlib

ARG INSTALL_OPCACHE=false
RUN if [ ${INSTALL_OPCACHE} = true ]; then \
    apk add --no-cache --update php${PHP_VERSION}-opcache \
;fi

ARG INSTALL_GRPC=false
RUN if [ ${INSTALL_GRPC} = true ]; then \
    apk add --no-cache --update --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing php${PHP_VERSION}-pecl-grpc \
    # php82-pecl-grpc-1.58.0-r0.apk
;fi

# make bash default shell
# RUN sed -e 's;/bin/ash$;/bin/bash;g' -i /etc/passwd

COPY ./images/php/base/conf.d/app.ini /etc/php${PHP_VERSION}/conf.d/

COPY ./images/php/base/.bashrc /home/${APP_USER_NAME}/.bashrc
COPY ./images/php/base/.bashrc /root/.bashrc

# Create symlink for php - make "php" as command available by creating a symlink 
RUN ln -s /usr/bin/php${PHP_VERSION} /usr/bin/php

# Setup document root
WORKDIR $APP_CODE_PATH

FROM base as local

# add app user to sudoers
# see https://ostechnix.com/add-delete-and-grant-sudo-privileges-to-users-in-alpine-linux/ for adding sudo
# see https://askubuntu.com/a/340669 for not requiring a sudo pw
# RUN echo "root ALL=(ALL) NOPASSWD: ALL " | tee -a "/etc/sudoers.d/users" && \
    # echo "${APP_USER_NAME} ALL=(ALL) NOPASSWD: ALL " | tee -a "/etc/sudoers.d/users"

ARG INSTALL_MYSQL_CLIENT=false
RUN if [ ${INSTALL_MYSQL_CLIENT} = true ]; then \
    apk add --no-cache --update mysql-client \
;fi

ARG INSTALL_REDIS=false
RUN if [ ${INSTALL_REDIS} = true ]; then \
    apk add --no-cache --update redis \
;fi

ARG INSTALL_XDEBUG=false
RUN if [ ${INSTALL_XDEBUG} = true ]; then \
    apk add --no-cache --update php${PHP_VERSION}-xdebug \
    # ensure that xdebug is not enabled by default
    && rm -f /etc/php${PHP_VERSION}/conf.d/00_xdebug.ini \
;fi

COPY ./images/php/base/conf.d/app-${ENV}.ini /etc/php${PHP_VERSION}/conf.d/

FROM base as production
