#!/bin/sh

cd /app

MEMORY_LIMIT="${MEMORY_LIMIT:=512M}"
PORT="${OCTANE_PORT:=9501}"
HOST="${OCTANE_HOST:=0.0.0.0}"
WORKERS="${OCTANE_WORKERS:=auto}"
TASK_WORKERS="${OCTANE_TASK_WORKERS:=auto}"
MAX_REQUEST="${OCTANE_MAX_REQUEST:=1024}"

# echo "memory_limit=${MEMORY_LIMIT}" > /usr/local/etc/php/conf.d/memory-limit.ini

echo "MEMORY_LIMIT=${MEMORY_LIMIT}"
echo "PORT=${PORT}"
echo "HOST=${HOST}"
echo "WORKERS=${WORKERS}"
echo "TASK_WORKERS=${TASK_WORKERS}"
echo "MAX_REQUEST=${MAX_REQUEST}"
set -xe

if [ "$OCTANE_WATCH_MODE" = "true" ]; then
  npm install --save-dev chokidar
  php -d memory_limit=512M /app/artisan octane:start  --watch --port=${PORT} --host=${HOST} \
   --workers=${WORKERS} \
   --task-workers=${TASK_WORKERS}
   --max-requests=${MAX_REQUEST}
else
  php -d memory_limit=512M /app/artisan octane:start --port=${PORT} --host=${HOST} \
  --workers=${WORKERS}  \
  --task-workers=${TASK_WORKERS}
  --max-requests=${MAX_REQUEST}
fi