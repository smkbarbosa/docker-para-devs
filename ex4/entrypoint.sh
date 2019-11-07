#!/bin/bash
set -e

/usr/local/bin/start.sh && "$@" 

#set - start.sh "$@"

exec "$@"