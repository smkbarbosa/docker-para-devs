#!/bin/bash
set -e

cd  /app
git clone $GIT blog
cd blog

source /venv/bin/activate
pip install -r requirements.txt

exec gunicorn -w 4 -b 0.0.0.0:5000 wsgi:app
# exec /usr/sbin/httpd -DFOREGROUND "$@"