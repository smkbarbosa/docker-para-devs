#!/bin/bash
set -e
git clone https://github.com/marfebr/blog 
cd blog && pip install -r requirements.txt
exec gunicorn -w 4 -b 0.0.0.0:5000 wsgi:app
# exec /usr/sbin/httpd -DFOREGROUND "$@"