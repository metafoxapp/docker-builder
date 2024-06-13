# docker-builder
build docker image


**Build foxsystem/php:fpm**
```bash
docker buildx build ./php --tag=foxsystem/php:fpm --target=fpm --push --file=Dockerfile

**Build foxsystem/php:swoole**
```
docker buildx build ./php --tag=foxsystem/php:swoole --target=swoole --push --file=Dockerfile
```