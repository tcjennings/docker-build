FROM tcjennings/rpi-node:lts

LABEL org.label-schema.schema-version="1.0" \
      org.label-schema.name="rpi-smartthings-nodeproxy" \
      org.label-schema.description="SmartThings Node Proxy for Raspberry Pi" \
      org.label-schema.version="1.0.2" \
      org.label-schema.docker.cmd="docker run -d -p 8080:8080 -e ENABLED_PLUGINS='' --device=/dev/ttyUSB0 rpi-smartthings-nodeproxy" \
      org.label-schema.build-date="2017-03-23"

ENV PYTHON=/usr/bin/python2.7

RUN apt-get install python2.7 build-essential \
 && mkdir -p /stnp/plugins \
 && wget -O - https://github.com/redloro/smartthings/tarball/master \
  | tar -xzvf - --wildcards --strip-components=2 -C /stnp/ redloro-smartthings-*/smartthings-nodeproxy/ \
 && cd /stnp \
 && rm -f restart.me smartthings-nodeproxy.service \
 && npm install \
 && apt-get remove build-essential --purge \
 && rm -rf /tmp/* 

COPY docker-entrypoint.sh /docker-entrypoint.sh
COPY config.json /stnp/config.json

EXPOSE 8080

ENTRYPOINT ["/docker-entrypoint.sh"]
