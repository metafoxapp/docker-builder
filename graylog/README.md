- Copy `.env.example` to `.env`
- Copy `docker-compose.example.yml` to `docker-compose.yml`
- Run `docker network create log_server` to create a new network. 
- Run `docker-compoose up -d`
- Run `docker-compose logs -f graylog`
- Open [http://localhost:9000](http://localhost:9000) and login with user `admin` and password from log
- Follow initial setup guide to init graylog

After server restarted

- Login with user admin and root password in `.env` file.
- Open System / Input 
- Select `GELF UDP` and press `Launch New Input`
- Fill title `GELF UDP` and keep port as default `12201` and click `Launch Input`


*Test*

Open terminal and run 

```bash
echo '{"version": "1.1","host":"example.org","short_message":"A short message that helps you identify what is going on","full_message":"Backtrace here\n\nmore stuff","level":1,"_user_id":9001,"_some_info":"foo","_some_env_var":"bar"}' | gzip | nc -u -w 1 127.0.0.1 12201
```

Open [http://localhost:9000/search](http://localhost:9000/search) to see results.


Integrate to other container.

Edit associate `docker-compose.yml`, add networks 

```yaml
services:
  app:
    # other options
    networks:
      # other network 
      - log_server
networks:
  log_server:
    external: true
```

Integration with laravel

Follow instruction at https://github.com/hedii/laravel-gelf-logger to integrate with gray log
Note that use `graylog` as host

```text
    // This optional option determines the host that will receive the
    // gelf log messages. Default is 127.0.0.1
    'host' => 'graylog',
```
