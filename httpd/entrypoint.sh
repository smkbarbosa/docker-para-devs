#!/bin/bash
set -e
set - httpd-foreground "$@"
exec "$@"