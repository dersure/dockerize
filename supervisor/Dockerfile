FROM alpine:latest

RUN apk update && apk add --no-cache supervisor

RUN mkdir /var/log/supervisor

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY ./conf/*.conf /etc/supervisor/conf.d

RUN addgroup -S www && adduser -S www -G www

RUN chown www:www /var/log/supervisor && chown www:www /var/run

USER www

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
