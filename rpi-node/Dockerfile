FROM resin/rpi-raspbian:jessie

LABEL org.label-schema.schema-version="1.0" \
      org.label-schema.name="rpi-node" \
      org.label-schema.description="Node.js for Raspberry Pi" \
      org.label-schema.version="6.10.1" \
      org.label-schema.docker.cmd="docker run -d rpi-node" \
      org.label-schema.build-date="2017-03-23" \
      com.tobyjennings.base-image="resin/rpi-raspbian:jessie" \
      com.tobyjennings.architecture="arm6" 

RUN apt-get update \
 && apt-get install wget \
 && apt-get clean
RUN wget -O - https://nodejs.org/dist/v6.10.1/node-v6.10.1-linux-armv6l.tar.xz \
  | tar -xJvf - --strip-components=1 -C /usr/local/ \
 && rm -rf /tmp/* 

ENV NODE=/usr/local/bin/node
ENV NPM=/usr/local/bin/npm

ENTRYPOINT ["/usr/local/bin/node"]
