#!/bin/sh

docker buildx create --name foxsystem --use

echo build production

docker buildx build --push \
--platform linux/arm64/v8,linux/amd64 \
--tag foxsystem/metafox-fpm:production \
--target production \
. -f php-fpm.dockerfile


echo build develop

docker buildx build --push \
--platform linux/arm64/v8,linux/amd64 \
--tag foxsystem/metafox-fpm:develop \
--target develop \
. -f php-fpm.dockerfile


echo build performance


docker buildx build --push \
--platform linux/arm64/v8,linux/amd64 \
--tag foxsystem/metafox-fpm:performance \
--target performance \
. -f php-fpm.dockerfile


echo build loadtest

docker buildx build --push \
--platform linux/arm64/v8,linux/amd64 \
--tag foxsystem/metafox-fpm:loadtest \
--target loadtest \
. -f php-fpm.dockerfile