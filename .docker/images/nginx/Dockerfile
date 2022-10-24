ARG NGINX_VERSION
FROM nginx:${NGINX_VERSION} as base

COPY ./images/nginx/sites/default.conf /etc/nginx/conf.d/

ARG APP_CODE_PATH
ARG FAST_CGI=php-fpm
RUN sed -i "s#root __NGINX_ROOT;#root $APP_CODE_PATH/public;#" /etc/nginx/conf.d/default.conf \
    && sed -i "s/fastcgi_pass _FastCGI_Server:/fastcgi_pass $FAST_CGI:/" /etc/nginx/conf.d/default.conf

FROM base as local

COPY ./images/nginx/ssl/ /etc/nginx/ssl/
COPY ./logs/nginx/ /var/log/nginx/
