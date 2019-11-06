#!/bin/sh
set -e
set - httpd-foreground "$@"
exec "$@"