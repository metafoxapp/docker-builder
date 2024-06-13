ARG PHP_VERSION=8.2
ARG NODE_VERSION=16.20
ARG MEMORY_LIMIT=512M
ARG USERNAME=daemon
ARG USER_UID=1000
ARG USER_GID=$USER_UID

FROM node:${NODE_VERSION}-slim as node_base

FROM php:${PHP_VERSION}-fpm-alpine as builder

RUN apk add --no-cache --virtual .build-deps $PHPIZE_DEPS  \
    imagemagick-dev \
    libzip-dev \
    libpng-dev \
    gettext gettext-dev \
    icu-data-full \
    zlib-dev \
    icu-dev \
    libpq-dev \
    linux-headers libxml2 \
    openldap-dev \
    libmemcached-dev  \
    && docker-php-ext-install bcmath \
    pcntl \
    intl \
    gettext \
    calendar \
    zip \
    exif \
    pdo_pgsql \
    pdo_mysql \
    sockets \
    ldap \
    gd \
    opcache  \
    && pecl install igbinary  \
    && pecl install --nobuild memcached \
    && cd "$(pecl config-get temp_dir)/memcached" \
    && phpize  \
    && ./configure --enable-memcached-igbinary && \
    make -j$(nproc) \
    && make install \
    && pecl install imagick redis swoole  \
    && docker-php-ext-enable imagick redis igbinary memcached swoole opcache


FROM builder as production

RUN apk add \
    zip \
    unzip \
    vim \
    ffmpeg \
    postgresql-client \
    mariadb-client \
    supervisor \
    && chmod +x /usr/bin/pg_dump /usr/bin/pg_restore

## add node support
COPY --from=node_base /usr/local/bin /usr/local/bin
COPY --from=node_base /usr/local/lib/node_modules /usr/local/lib/node_modules
COPY ./production /

RUN pecl install xdebug
COPY ./develop /

ENV DISABLE_DEFAULT_SERVER=true
ENV OCTANE_SERVER=swoole
ENV OCTANE_HOST=0.0.0.0
ENV OCTANE_PORT=9501
ENV OCTANE_WORKERS=auto
ENV OCTANE_TASK_WORKERS=auto
ENV OCTANE_MAX_REQUEST=1024
ENV MFOX_ENABLE_OCTANE=true
ENV OCTANE_WATCH_MODE=false

#USER $USERNAME

WORKDIR /app

EXPOSE 9501

ENTRYPOINT ["/usr/local/bin/supervisor-entrypoint.sh"]


