ARG PHP_VERSION=8.2.8-fpm
FROM php:${PHP_VERSION} as fpm_builder

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections \
    && apt-get update -y \
    && apt-get install -y \
    build-essential \
    apt-utils \
    autoconf  \
    pkg-config \
    libmemcached-dev \
    zlib1g-dev \
    libzip-dev \
    zip \
    unzip \
    ffmpeg \
    postgresql-client \
    mariadb-client \
    supervisor \
    && chmod +x /usr/bin/pg_dump \
    /usr/bin/pg_restore \
    && apt-get purge -y --auto-remove \
    && rm -rf /var/lib/apt/lists/*


RUN pecl channel-update pear.php.net \
    && pecl install \
    redis\
    memcached

WORKDIR /app

FROM fpm_builder as develop

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections \
    && apt-get update -y \
    && apt-get install -y \
    wget \
    git \
    vim  \
    nano  \
    && apt-get purge -y --auto-remove  \
    && rm -rf /var/lib/apt/lists/*

RUN pecl channel-update pear.php.net \
    && pecl install \
    xdebug \
    pcov



# Install memcached
RUN pecl channel-update pear.php.net \
    && pecl install \
    redis\
    xdebug \
    pcov \
    memcached

##############################################################################
##############################################################################
# Target prod
# Image name foxystem/metafox-fpm:prod
FROM bitnami/php-fpm:${PHP_VERSION} as production

RUN apt-get update -y  \
    && apt-get install -y \
    ffmpeg \
    supervisor  \
    vim \
    postgresql-client \
    mariadb-client \
    && apt-get purge -y --auto-remove \
    && rm -rf /var/lib/apt/lists/*


COPY --from=fpm_builder /opt/bitnami/php/lib/php/extensions/memcached.so /opt/bitnami/php/lib/php/extensions/memcached.so
COPY --from=fpm_builder /opt/bitnami/php/lib/php/extensions/swoole.so /opt/bitnami/php/lib/php/extensions/swoole.so
COPY --from=fpm_builder /opt/bitnami/php/lib/php/extensions/redis.so /opt/bitnami/php/lib/php/extensions/redis.so
COPY --from=fpm_builder /usr/bin/mysqlimport /usr/bin/mysqlimport
COPY --from=fpm_builder /usr/bin/zip /usr/bin/zip
COPY --from=fpm_builder /usr/bin/unzip /usr/bin/unzip
COPY performance/fpm-www.conf /opt/bitnami/php/etc/php-fpm.d/www.conf
COPY performance/supervisor.conf /etc/supervisor/supervisord.conf
COPY production/*.ini /opt/bitnami/php/etc/conf.d
RUN sed -i "s|zend_extension = opcache| |g" /opt/bitnami/php/lib/php.ini



