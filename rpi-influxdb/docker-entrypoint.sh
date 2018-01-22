#!/bin/bash

if [[ -f /run/secrets/influxdb.key && -f /run/secrets/influxdb.crt ]]; then
 export INFLUXDB_HTTP_HTTPS_ENABLED=TRUE
 export INFLUXDB_HTTP_HTTPS_CERTIFICATE=/run/secrets/influxdb.crt
 export INFLUXDB_HTTP_HTTPS_PRIVATE_KEY=/run/secrets/influxdb.key
fi

set -e

if [ "${1:0:1}" = '-' ]; then
  set -- influxd "$@"
fi

exec "$@"
