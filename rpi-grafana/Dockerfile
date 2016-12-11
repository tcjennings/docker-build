FROM resin/rpi-raspbian:jessie

LABEL org.label-schema.schema-version="1.0" \
      org.label-schema.name="grafana" \
      org.label-schema.description="Grafana" \
      org.label-schema.version="4.0.2" \
      org.label-schema.docker.cmd="docker run -d -p 3000:3000 -v data:/var/lib/grafana -v log:/var/log/grafana tcjennings/rpi-grafana" \
      org.label-schema.build-date="2016-12-10" \
      com.tobyjennings.base-image="resin/rpi-raspbian:jessie" \
      com.tobyjennings.architecture="arm6hf" 

RUN apt-get update \
 && apt-get upgrade -y \
 && apt-get install -y libfontconfig wget \
 && wget -O /tmp/grafana.deb https://github.com/tcjennings/raspberrypi-packages/raw/master/grafana/v4.0.2/grafana_4.0.2-1481430694_armhf.deb \
 && dpkg -i /tmp/grafana.deb \
 && apt-get clean \
 && rm -rf /tmp/* 

VOLUME /var/lib/grafana
VOLUME /var/log/grafana

EXPOSE 3000

ENV GF_PATHS_DATA /var/lib/grafana/
ENV GF_PATHS_PLUGINS /var/lib/grafana/plugins
ENV GF_PATHS_LOGS /var/log/grafana/

ENTRYPOINT ["/usr/sbin/grafana-server"]
CMD ["-config","/etc/grafana/grafana.ini","-homepath","/usr/share/grafana"]

