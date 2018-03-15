FROM tcjennings/rpi-raspbian:jessie as builder

ARG build_date
ARG architecture=armhf
ARG telegraf_version=1.5.2

RUN apt-get update \
 && apt-get install -y snmp unzip smistrip patch wget \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf /tmp/* 

RUN mkdir -p /opt/telegraf \
 && curl https://dl.influxdata.com/telegraf/releases/telegraf-${telegraf_version}_linux_${architecture}.tar.gz \
  #| tar -xvzf - --strip-components=2 -C / \
  | tar -xvzf - --strip-components=2 -C /opt/telegraf \
 && curl -o /tmp/mib-downloader.deb http://http.us.debian.org/debian/pool/non-free/s/snmp-mibs-downloader/snmp-mibs-downloader_1.1+nmu1_all.deb \
 && dpkg -i /tmp/mib-downloader.deb \
 && rm -rf /tmp/* \
 && mkdir -p /etc/telegraf/telegraf.d \
 && rm -f /etc/snmp/snmp.conf \
 && touch /etc/snmp/snmp.conf

FROM arm32v6/alpine:3.7
RUN apk update && apk add net-snmp-tools bash
COPY --from=builder /opt/telegraf/* /
COPY --from=builder /etc/telegraf/* /etc/telegraf/
COPY --from=builder /var/lib/snmp/mibs/iana/* /var/lib/snmp/mibs/ietf/* /usr/share/snmp/mibs/
COPY docker-entrypoint.sh /docker-entrypoint.sh

VOLUME /etc/telegraf/telegraf.conf.d

LABEL org.label-schema.schema-version="1.0" \
      org.label-schema.name="rpi-telegraf" \
      org.label-schema.description="Telegraf with MIB file collection" \
      org.label-schema.version="${telegraf_version}" \
      org.label-schema.docker.cmd="docker run -d rpi-telegraf" \
      org.label-schema.build-date="${build_date}" \
      com.tobyjennings.base-image="arm32v6/alpine:3.7" \
      com.tobyjennings.architecture="${architecture}"

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["telegraf","--config","/etc/telegraf/telegraf.conf","--config-directory","/etc/telegraf/telegraf.conf.d"]
