ARG NGINX_VERSION
FROM nginx:${NGINX_VERSION} as base

COPY ./images/nginx/sites/default.conf /etc/nginx/conf.d/

ARG APP_CODE_PATH
RUN sed -i "s#root __NGINX_ROOT;#root $APP_CODE_PATH/public;#" /etc/nginx/conf.d/default.conf

FROM base as local

COPY ./images/nginx/ssl/ /etc/nginx/ssl/
COPY ./logs/nginx/ /var/log/nginx/
