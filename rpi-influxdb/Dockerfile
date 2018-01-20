FROM resin/rpi-raspbian:jessie

ENV INFLUXDB_VERSION=1.4.2

LABEL org.label-schema.schema-version="1.0" \
      org.label-schema.name="rpi-influxdb" \
      org.label-schema.description="InfluxDB for CollectD metrics with types.db" \
      org.label-schema.version="1.4.2" \
      org.label-schema.docker.cmd="docker run -d -p 8083:8083 -p 8086:8086 -p 25826:25826/udp rpi-influxdb" \
      org.label-schema.build-date="2018-01-20" \
      com.tobyjennings.base-image="resin/rpi-raspbian:jessie" \
      com.tobyjennings.architecture="arm6hf" 

RUN apt-get update \
 && apt-get install wget \
 && apt-get clean \
 && wget -O - https://dl.influxdata.com/influxdb/releases/influxdb-${INFLUXDB_VERSION}_linux_armhf.tar.gz \
  | tar -xvzf - --strip-components=2 -C / \
 && mkdir -p /var/lib/influxdb/wal \
 && mkdir -p /var/lib/influxdb/data \
 && mkdir -p /var/lib/influxdb/meta \
 && mkdir -p /usr/share/collectd \
 && rm -rf /tmp/* 

COPY docker-entrypoint.sh /docker-entrypoint.sh
COPY influxdb.conf /etc/influxdb/influxdb.conf
COPY types.db /usr/share/collectd/types.db

ENV INFLUXDB_CONFIG_PATH /etc/influxdb/influxdb.conf

EXPOSE 8083 8086 25826/udp

VOLUME /var/lib/influxdb

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["influxd"]
