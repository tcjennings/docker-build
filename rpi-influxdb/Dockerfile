FROM resin/rpi-raspbian:jessie as runtime
ARG influxdb_version=1.4.3

RUN curl https://dl.influxdata.com/influxdb/releases/influxdb-${influxdb_version}_linux_armhf.tar.gz \
  | tar -xvzf - -C /opt \
 && mkdir -p /var/lib/influxdb/wal \
 && mkdir -p /var/lib/influxdb/data \
 && mkdir -p /var/lib/influxdb/meta \
 && rm -rf /tmp/* 

FROM scratch
LABEL org.label-schema.schema-version="1.0" \
      org.label-schema.name="rpi-influxdb" \
      org.label-schema.description="InfluxDB for CollectD metrics with types.db" \
      org.label-schema.version="${influxdb_version}" \
      org.label-schema.docker.cmd="docker run -d -p 8086:8086 -p 25826:25826/udp rpi-influxdb" \
      org.label-schema.build-date="2018-02-05" \
      com.tobyjennings.base-image="scratch" \
      com.tobyjennings.architecture="arm6hf" 
COPY influxdb.conf /etc/influxdb/influxdb.conf
COPY types.db /usr/share/collectd/types.db
COPY --from=runtime /var/lib/influxdb /var/lib/influxdb
COPY --from=runtime /opt/influxdb-${influxdb_version}*/* /

ENV INFLUXDB_CONFIG_PATH /etc/influxdb/influxdb.conf

EXPOSE 8086 25826/udp

VOLUME /var/lib/influxdb

ENTRYPOINT ["influxd"]
