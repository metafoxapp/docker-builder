# Docker For MetaFox

In this image

php + swoole + fpm + postgres client + required extension

SUPPORT ENV: 

```txt
MEMORY_LIMIT=512M
PORT=9501
HOST=0.0.0.0
WORKERS=auto
MAX_REQUEST=500
```

swoole server expose port: 9501

fpm server expose port: 9000

PHP extensions
- apcu
- bcmath
- bz2
- calendar
- Core
- ctype
- curl
- date
- dom
- exif
- fileinfo
- filter
- ftp
- gd
- gettext
- gmp
- hash
- iconv
- imagick
- intl
- json
- ldap
- libxml
- mbstring
- memcached
- mysqlnd
- openssl
- pcntl
- pcov
- pcre
- PDO
- pdo_mysql
- pdo_pgsql
- pdo_sqlite
- pgsql
- Phar
- posix
- random
- readline
- redis
- Reflection
- session
- SimpleXML
- soap
- sockets
- sodium
- SPL
- sqlite3
- standard
- swoole
- tidy
- tokenizer
- xml
- xmlreader
- xmlwriter
- yaml
- zip
- zlib