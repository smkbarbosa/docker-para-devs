#!/bin/sh
set -e
set - gunicorn.sh "$@"
exec "$@"