FROM tcjennings/rpi-raspbian:jessie

ARG build_date
ARG architecture=armhf
ARG telegraf_version=1.5.1

LABEL org.label-schema.schema-version="1.0" \
      org.label-schema.name="rpi-telegraf" \
      org.label-schema.description="Telegraf" \
      org.label-schema.version="${telegraf_version}" \
      org.label-schema.docker.cmd="docker run -d rpi-telegraf" \
      org.label-schema.build-date="${build_date}" \
      com.tobyjennings.base-image="resin/rpi-raspbian:jessie" \
      com.tobyjennings.architecture="${architecture}"

RUN apt-get update \
 && apt-get install -y wget \
 && apt-get clean \
 && wget -O - https://dl.influxdata.com/telegraf/releases/telegraf-${telegraf_version}_linux_${architecture}.tar.gz \
  | tar -xvzf - --strip-components=2 -C / \
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf /tmp/* \
 && mkdir -p /etc/telegraf/telegraf.d

COPY docker-entrypoint.sh /docker-entrypoint.sh

VOLUME /etc/telegraf/telegraf.d

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["telegraf","--config","/etc/telegraf/telegraf.conf","--config-directory","/etc/telegraf/telegraf.conf.d"]
