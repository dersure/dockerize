ARG BASE_IMAGE
FROM ${BASE_IMAGE} as base

FROM base as local

RUN apk add --no-cache --update openssh curl python3

# ARG RABBITMQADMIN_VERSION=3_6_16

# RUN curl https://raw.githubusercontent.com/rabbitmq/rabbitmq-management/rabbitmq_v${RABBITMQADMIN_VERSION}/bin/rabbitmqadmin -o /usr/local/bin/rabbitmqadmin \

RUN curl https://raw.githubusercontent.com/rabbitmq/rabbitmq-server/main/deps/rabbitmq_management/bin/rabbitmqadmin -o /usr/local/bin/rabbitmqadmin \
# chmod +x on a file (your script) only means, that you'll make it executable. Right click on your script and chose
# Properties -> Permissions -> Allow executing file as program, leaves you with the exact same result as the command in terminal.
        && chmod +x /usr/local/bin/rabbitmqadmin

# ENV RABBIT_HOST=127.0.0.1 RABBIT_PORT=15672 RABBIT_USER=guest RABBIT_PASSWORD=guest RABBIT_VHOST=/

ARG APP_SSH_PASSWORD
RUN echo "$APP_USER_NAME:$APP_SSH_PASSWORD" | chpasswd 2>&1

# Required to start sshd, otherwise the container will error out on startup with the message
# "sshd: no hostkeys available -- exiting."
# @see https://stackoverflow.com/a/65348102/413531 
RUN ssh-keygen -A

# we use SSH deployment configuration in PhpStorm for local development
EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
