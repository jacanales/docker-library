FROM jwilder/dockerize AS dockerize
FROM composer:latest AS composer

## Base target
FROM php:7.4-fpm-alpine AS base

LABEL maintainer = "Jesús Antonio Canales Diez <jcanales@zonadev.es>"

# Install composer and Dockerize
COPY --from=composer /usr/bin/composer /usr/local/bin/composer
COPY --from=dockerize /usr/local/bin/dockerize /usr/local/bin/dockerize

# Add the directory where composer put binaries to the system path
ENV PATH="$HOME/.composer/vendor/bin:${PATH}"

WORKDIR /code

ENTRYPOINT ["docker-php-entrypoint", "dockerize"]
CMD ["php-fpm"]

## Target for dev environments
FROM base AS dev
