ARG ROADRUNNER_VERSION=latest
ARG BASE_IMAGE
FROM ghcr.io/roadrunner-server/roadrunner:${ROADRUNNER_VERSION} as roadrunner
FROM ${BASE_IMAGE} as base

# Install roadrunner - copy roadrunner binary
COPY --from=roadrunner /usr/bin/rr /usr/local/bin/rr
# COPY --from=ghcr.io/roadrunner-server/roadrunner:latest /usr/bin/rr /usr/local/bin/rr

# Switch to use a non-root user from here on
USER $APP_USER_NAME

# Expose the port roadrunner is reachable on
EXPOSE 8080 443

# Start roadrunner
ENTRYPOINT ["rr"]
# CMD ["rr", "serve", "-c", "/var/www/.rr.yaml"]

FROM base as local

FROM base as production
