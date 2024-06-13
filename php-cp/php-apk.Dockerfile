ARG PHP_VERSION=8.2
ARG NODE_VERSION=16.20
ARG MEMORY_LIMIT=512M
ARG USERNAME=daemon
ARG USER_UID=1000
ARG USER_GID=$USER_UID

FROM node:${NODE_VERSION}-slim as node_builder

FROM php:${PHP_VERSION}-fpm-alpine as php_builder

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
    git \
    zip \
    unzip \
    ffmpeg \
    postgresql-client \
    mariadb-client \
    supervisor \
    && chmod +x /usr/bin/pg_dump /usr/bin/pg_restore \
    && docker-php-ext-install bcmath \
    pcntl \
    intl \
    gettext \
    calendar \
    exif \
    pdo_pgsql \
    pdo_mysql \
    sockets \
    ldap \
    gd \
    opcache  \
    && pecl channel-update pecl.php.net \
    && pecl install igbinary  \
    && pecl install --nobuild memcached \
    && cd "$(pecl config-get temp_dir)/memcached" \
    && phpize  \
    && ./configure --enable-memcached-igbinary && \
    make -j$(nproc) \
    && make install \
    && pecl install imagick redis  \
    && docker-php-ext-enable imagick redis igbinary memcached opcache

FROM php_builder as develop

FROM php_builder as production

RUN apk add --no-cache --virtual .build-deps $PHPIZE_DEPS  \
    && pecl channel-update pecl.php.net \
    && pecl install --configureoptions 'enable-sockets="no" enable-openssl="no" enable-mysqlnd="no" enable-swoole-curl="no" enable-cares="no" enable-brotli="no" enable-swoole-pgsql="no" with-swoole-odbc="no" with-swoole-oracle="no" enable-swoole-sqlite="no"' swoole \
    && docker-php-ext-enable swoole

ENV DISABLE_DEFAULT_SERVER=true
ENV OCTANE_SERVER=swoole
ENV OCTANE_HOST=0.0.0.0
ENV OCTANE_PORT=9501
ENV OCTANE_WORKERS=auto
ENV OCTANE_TASK_WORKERS=auto
ENV OCTANE_MAX_REQUEST=1024
ENV MFOX_ENABLE_OCTANE=true
ENV OCTANE_WATCH_MODE=false

#    && apk del .build-deps \
#    && rm -rf /var/cache/apk/*

WORKDIR /app

EXPOSE 9501

ENTRYPOINT ["/usr/local/bin/supervisor-entrypoint.sh"]

## add node support
COPY --from=node_builder /usr/local/bin /usr/local/bin
COPY --from=node_builder /usr/local/lib/node_modules /usr/local/lib/node_modules

FROM php_builder as debug

RUN pecl channel-update pecl.php.net \
    && pecl install xdebug





