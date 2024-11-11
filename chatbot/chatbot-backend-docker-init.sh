#!/bin/bash

if [[ $CHATBOT_ENV == "api" ]]; then
  if [[ $FLASK_ENV == "development" ]]; then
    export FLASK_DEBUG=1
    flask run --port=8502 --host="0.0.0.0"
  else
    export FLASK_DEBUG=0
    export FLASK_ENV=production
    gunicorn --workers 4 --bind 0.0.0.0:8502 "project:create_app()"
  fi
fi

if [[ $CHATBOT_ENV == "socketio" ]]; then
  gunicorn --workers=1 --worker-class=eventlet --bind=0.0.0.0:8503 wsgi:app
fi

if [[ $CHATBOT_ENV == "worker" ]]; then
  celery -A make_celery worker -l info -E
fi

if [[ $CHATBOT_ENV == "scheduler" ]]; then
  celery -A make_celery beat -l info
fi
