ARG NGINX_VERSION=alpine
FROM nginx:${NGINX_VERSION} as base

# Configure nginx - http
# COPY ./images/nginx/nginx.conf /etc/nginx/nginx.conf

# Configure nginx - default server
ARG APP_CODE_PATH
ARG NGINX_ROOT=$APP_CODE_PATH
ARG FAST_CGI=php-fpm
COPY ./images/nginx/sites/default.conf /etc/nginx/conf.d/
RUN sed -i "s#root __NGINX_ROOT;#root $NGINX_ROOT;#" /etc/nginx/conf.d/default.conf \
    && sed -i "s/fastcgi_pass _FastCGI_Server:/fastcgi_pass $FAST_CGI:/" /etc/nginx/conf.d/default.conf

# Configure nginx for development
FROM base as local
COPY ./logs/nginx/ /var/log/nginx/

# Configure nginx for production
FROM base as production
COPY ./images/nginx/ssl/ /etc/nginx/ssl/
