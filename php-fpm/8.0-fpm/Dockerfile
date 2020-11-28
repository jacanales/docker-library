ARG PHP_VERSION=8.0.0RC5
ARG PHP_VARIANT=fpm

FROM php:${PHP_VERSION}-${PHP_VARIANT}-buster AS base

LABEL maintainer = "Jesús Antonio Canales Diez <jcanales@zonadev.es>"

COPY . /code
WORKDIR /code

COPY --from=composer:2 /usr/bin/composer /usr/local/bin/composer

ENV PATH="$HOME/.composer/vendor/bin:${PATH}"

RUN groupadd -g 1000 composer \
  && useradd -r -u 1000 -g 1000 -s /bin/false composer \
  && chown -R composer:composer /usr/local/bin/composer

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    git \
    ssh \
    wget \
    libicu-dev \
    # RabbitMQ deps
    librabbitmq-dev \
    libssh-dev \
    # Kafka deps
    librdkafka-dev

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-install \
    bcmath \
    sockets

RUN pecl update-channels
RUN pecl install \
    apcu \
    redis \
    igbinary
    #amqp \
    #rdkafka \
    #grpc \
    #protobuf

ENTRYPOINT ["docker-php-entrypoint"]
CMD ["php-fpm"]

# DEV Image
FROM base AS dev

RUN pecl install xdebug