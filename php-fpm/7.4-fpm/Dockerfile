ARG PHP_VERSION=7.4.12
ARG PHP_VARIANT=fpm

FROM php:${PHP_VERSION}-${PHP_VARIANT} AS base

LABEL maintainer = "Jesús Antonio Canales Diez <jcanales@zonadev.es>"

WORKDIR /code

RUN apt update \
    && apt install -y --no-install-recommends \
        git \
        ssh \
        wget \
        supervisor \
        rsync \
        openssh-server \
        libbz2-dev \
        libpng-dev \
        libicu-dev \
        # RabbitMQ deps
        librabbitmq-dev \
        libssh-dev \
        # Kafka deps
        librdkafka-dev

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

RUN pecl install \
        apcu \
        redis \
        igbinary \
        amqp \
        rdkafka \
        grpc \
        protobuf

RUN docker-php-ext-enable \
        igbinary \
        apcu \
        redis

ENV XDEBUG_REMOTE_HOST 127.0.0.1

# Dockerize
ENV DOCKERIZE_VERSION v0.6.1
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

# Install composer
ENV PATH="$HOME/.composer/vendor/bin:${PATH}"
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY config/xdebug.ini /usr/local/etc/php/conf.d/20-xdebug.ini
COPY config/php.ini /usr/local/etc/php/conf.d/10-php.ini
COPY bin/phpenmod /usr/local/bin/phpenmod
COPY bin/phpdismod /usr/local/bin/phpdismod

EXPOSE 9000/tcp

ENTRYPOINT ["docker-php-entrypoint", "dockerize"]
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

# DEV Image
FROM base AS dev

RUN pecl install\
    xdebug

RUN docker-php-ext-enable \
    xdebug