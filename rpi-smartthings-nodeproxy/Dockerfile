FROM tcjennings/rpi-node:lts-armv6

ARG architecture="armv6"
ARG build_date
ARG repo="redloro"
ARG branch="master"

LABEL org.label-schema.schema-version="1.0" \
      org.label-schema.name="rpi-smartthings-nodeproxy" \
      org.label-schema.description="SmartThings Node Proxy for Raspberry Pi" \
      org.label-schema.version="1.0.2" \
      org.label-schema.docker.cmd="docker run -d -p 8080:8080 -e ENABLED_PLUGINS='' --device=/dev/ttyUSB0 rpi-smartthings-nodeproxy" 
#      org.label-schema.build-date=$build_date \
#      architecture=$architecture

ENV PYTHON=/usr/bin/python2.7

RUN apt-get install python2.7 build-essential libpcap-dev \
 && mkdir -p /stnp/plugins \
 && wget -O - https://github.com/${repo}/smartthings/tarball/${branch} \
  | tar -xzvf - --wildcards --strip-components=2 -C /stnp/ ${repo}-smartthings-*/smartthings-nodeproxy/ \
 && cd /stnp \
 && rm -f restart.me smartthings-nodeproxy.service config.json \
 && npm install \
 && npm install serialport@4.0.7 \
 && npm install https://github.com/node-pcap/node_pcap/tarball/master \
 && apt-get remove build-essential libpcap-dev libpcap0.8-dev --purge \
 && rm -rf /tmp/* 

COPY docker-entrypoint.sh /docker-entrypoint.sh
COPY config.json /stnp/config.json

EXPOSE 8080

ENTRYPOINT ["/docker-entrypoint.sh"]
