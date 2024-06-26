ARG PHP_VERSION=8.2
ARG NODE_VERSION=16.20
ARG MEMORY_LIMIT=512M
ARG USERNAME=daemon
ARG USER_UID=1000
ARG USER_GID=$USER_UID

FROM node:${NODE_VERSION}-slim as node_builder

FROM php:${PHP_VERSION}-fpm as php_builder

RUN apt-get update && apt-get install -y  \
    libzip-dev \
    libpng-dev \
    zlib1g-dev \
    libjpeg-dev \
    libonig-dev \
    libicu-dev \
    libssl-dev \
    gettext \
    libpq-dev \
    libldap-dev \
    libxml2 \
    libmemcached-dev  \
    git \
    zip \
    unzip \
    ffmpeg \
    postgresql-client \
    mariadb-client \
    supervisor \
    libmagickwand-dev \
    && chmod +x /usr/bin/pg_dump /usr/bin/pg_restore \
    && docker-php-source extract \
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
    && pecl install imagick redis pcov xdebug \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install ftp zip gd \
    && docker-php-ext-enable imagick redis igbinary memcached opcache ftp zip ldap \
    && docker-php-source delete \
    && apt-get clean \
    && apt-get purge -y --auto-remove

RUN sed -i 's/www-data/daemon/g' /usr/local/etc/php-fpm.d/www.conf

# Copy composer lasted bin
COPY --from=composer/composer:latest-bin /composer /usr/bin/composer

WORKDIR /app

FROM php_builder as fpm

# ENTRYPOINT ["/usr/local/bin/supervisor-entrypoint.sh"]

FROM php_builder as swoole

RUN pecl channel-update pecl.php.net \
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

EXPOSE 9501

## add node support
COPY --from=node_builder /usr/local/bin /usr/local/bin
COPY --from=node_builder /usr/local/lib/node_modules /usr/local/lib/node_modules

FROM php_builder as debug

RUN pecl channel-update pecl.php.net \
    && pecl install xdebug






