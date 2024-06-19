# Bullmq Dashboard

### Quick start with Docker

```
docker run -p 3000:3000 foxsystem/bullboard
```

will run bull-board interface on `localhost:3000` and connect to your redis instance on `localhost:6379` without
password.

To configurate redis see "Environment variables" section.

### Quick start with docker-compose

```yaml
services:
	bullboard:
		container_name: bullboard
		image: foxsystem/bullboard
		restart: always
		ports:
			- 3000:3000
```

will run bull-board interface on `localhost:3000` and connect to your redis instance on `localhost:6379` without
password.

see "Example with docker-compose" section for example with env parameters

### Environment variables

* `REDIS_HOST` - host to connect to redis (localhost by default)
* `REDIS_PORT` - redis port (6379 by default)
* `REDIS_DB` - redis db to use ('0' by default)
* `REDIS_USE_TLS` - enable TLS true or false (false by default)
* `REDIS_PASSWORD` - password to connect to redis (no password by default)
* `PROXY_PATH` - proxyPath for bull board, e.g. https://<server_name>/my-base-path/queues [docs] ('' by default)
* `ADMIN_USER` - login to restrict access to bull-board interface (disabled by default)
* `ADMIN_PASSWORD` - password to restrict access to bull-board interface (disabled by default)
* `QUEUE_NAMES` - list of queue names, etc: build, track-urls, send_mails ,...

### Restrict access with login and password

To restrict access to bull-board use `ADMIN_USER` and `ADMIN_PASSWORD` env vars.
Only when both `ADMIN_USER` and `ADMIN_PASSWORD` specified, access will be restricted with login/password

### Example with docker-compose

```yaml
services:
  redis:
    container_name: redis
    image: redis:7.0-alpine
    restart: always
    volumes:
      - redis_db_data:/data
  bullboard:
    image: foxsystem/bullboard
    restart: always
    ports:
      - 3000:3000
    environment:
      REDIS_HOST: redis
      REDIS_PORT: 6379
      REDIS_PASSWORD: example-password
      REDIS_USE_TLS: false
      ADMIN_PASSWORD: "admin"
    depends_on:
      - redis
volumes:
  redis_db_data:
    external: false
networks:
  bullmq:
    driver: bridge

```
