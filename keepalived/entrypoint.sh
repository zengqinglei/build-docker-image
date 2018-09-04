#!/bin/sh
set -e

chmod -R a+x /etc/keepalived/scripts/

exec "$@"
