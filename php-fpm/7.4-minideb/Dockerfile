FROM jwilder/dockerize AS dockerize
FROM composer:latest AS composer

FROM bitnami/php-fpm:7.4.2-prod as base

LABEL maintainer = "Jesús Antonio Canales Diez <jcanales@zonadev.es>"

# Install composer and Dockerize
COPY --from=composer /usr/bin/composer /usr/local/bin/composer
COPY --from=dockerize /usr/local/bin/dockerize /usr/local/bin/dockerize

WORKDIR /code

ENTRYPOINT ["php-fpm" , "-F"]
