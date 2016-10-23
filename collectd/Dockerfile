FROM resin/rpi-raspbian:jessie

LABEL org.label-schema.schema-version = "1.0" \
      org.label-schema.name = "collectd-snmp" \
      org.label-schema.description = "Collectd with SNMP-tools and MIBs downloaded." \
      org.label-schema.docker.cmd = "docker run -d -v collectd.d:/etc/collectd/collectd.d collectd" \
      org.label-schema.build-date = "2016-10-23" \
      com.tobyjennings.base-image = "resin/rpi-raspbian:jessie" \
      com.tobyjennings.architecture = "arm6hf" 

RUN apt-get update \
 && apt-get install collectd collectd-utils snmp patch smistrip wget unzip \
 && wget -O /tmp/mib-downloader.deb http://http.us.debian.org/debian/pool/non-free/s/snmp-mibs-downloader/snmp-mibs-downloader_1.1+nmu1_all.deb \
 && dpkg -i /tmp/mib-downloader.deb \
 && apt-get clean \
 && rm -rf /tmp/* \
 && rm -f /etc/snmp/snmp.conf \
 && touch /etc/snmp/snmp.conf

ADD docker-entrypoint.sh /docker-entrypoint.sh

VOLUME /etc/collectd/collectd.conf.d

ENTRYPOINT ["/docker-entrypoint.sh"]

