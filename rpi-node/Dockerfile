FROM resin/rpi-raspbian:jessie

ARG architecture=armv6
ARG node_version=6.11.1
ARG build_date

LABEL org.label-schema.schema-version="1.0" \
      org.label-schema.name="rpi-node" \
      org.label-schema.description="Node.js for Raspberry Pi" \
      org.label-schema.version=$node_version \
      org.label-schema.docker.cmd="docker run -d rpi-node" \
      org.label-schema.build-date=$build_date \
      com.tobyjennings.base-image="resin/rpi-raspbian:jessie" \
      com.tobyjennings.architecture=$architecture

RUN apt-get update \
 && apt-get install wget \
 && apt-get clean
RUN wget -O - https://nodejs.org/dist/v${node_version}/node-v${node_version}-linux-${architecture}l.tar.xz \
  | tar -xJvf - --strip-components=1 -C /usr/local/ \
 && rm -rf /tmp/* 

ENV NODE=/usr/local/bin/node
ENV NPM=/usr/local/bin/npm

ENTRYPOINT ["/usr/local/bin/node"]
