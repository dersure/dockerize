FROM alpine:latest

RUN apk update && apk add --no-cache supervisor

# COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY ./supervisor/*.conf /etc/supervisor/conf.d

RUN mkdir /var/log/supervisor

RUN addgroup -S www && adduser -S www -G www

RUN chown www:www /var/log/supervisor && chown www:www /var/run

USER www

EXPOSE 9001

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
