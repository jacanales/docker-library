FROM jwilder/dockerize AS dockerize
FROM composer:latest AS composer

FROM php:7.4-fpm

LABEL maintainer = "Jesús Antonio Canales Diez <jcanales@zonadev.es>"

WORKDIR /code

RUN echo "\nexport TERM=xterm" >> /etc/bash.bashrc

RUN apt update \
    && apt install -y --no-install-recommends \
        wget \
        git \
        supervisor \
        rsync \
        openssh-server \
        libbz2-dev \
        libpng-dev
RUN rm -rf /var/lib/apt/lists/*

ENV DOCKERIZE_VERSION v0.6.1
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

# Install composer
COPY --from=composer /usr/bin/composer /usr/local/bin/composer
ENV PATH="$HOME/.composer/vendor/bin:${PATH}"
RUN composer global require "hirak/prestissimo"

RUN pecl install \
        igbinary \
        apcu \
        redis \
        xdebug

RUN docker-php-ext-enable \
        igbinary \
        apcu \
        redis

ENV XDEBUG_REMOTE_HOST 127.0.0.1

COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY config/xdebug.ini /usr/local/etc/php/conf.d/20-xdebug.ini
COPY config/php.ini /usr/local/etc/php/conf.d/10-php.ini
COPY bin/phpenmod /usr/local/bin/phpenmod
COPY bin/phpdismod /usr/local/bin/phpdismod

WORKDIR /code

ENTRYPOINT ["docker-php-entrypoint", "dockerize"]
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
