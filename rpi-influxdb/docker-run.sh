#!/bin/bash

docker run -it -d -p 8083:8083 -p 8086:8086 -p 25826:25826/udp \
--env-file influxdb-collectd.env \
--name influxdb \
"$1"
