#!/bin/bash
set -e
exec /usr/sbin/httpd -DFOREGROUND "$@"