ARG BASE_IMAGE
FROM ${BASE_IMAGE} as base

RUN echo ${PHP_VERSION}
RUN apk add --no-cache --update php-fpm~=$PHP_VERSION && ln -s /usr/sbin/php-fpm8 /usr/bin/php-fpm

COPY ./images/php/fpm/php-fpm.d/ /etc/php8/php-fpm.d/
COPY ./images/php/fpm/conf.d/app-fpm.ini /etc/php8/conf.d/

RUN sed -i "s/__APP_USER_NAME/$APP_USER_NAME/" /etc/php8/php-fpm.d/* \
    && sed -i "s/__APP_GROUP_NAME/$APP_GROUP_NAME/" /etc/php8/php-fpm.d/*

USER $APP_USER_NAME

EXPOSE 9000

# CMD ["php-fpm"]
CMD ["php-fpm", "-F"]

FROM base as local

COPY ./images/php/fpm/conf.d/${ENV}/* /etc/php8/conf.d/
