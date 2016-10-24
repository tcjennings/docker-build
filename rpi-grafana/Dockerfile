FROM resin/rpi-raspbian:jessie

LABEL org.label-schema.schema-version="1.0" \
      org.label-schema.name="grafana" \
      org.label-schema.description="Grafana" \
      org.label-schema.version="3.1.1" \
      org.label-schema.docker.cmd="docker run -d -p 3000:3000 -v data:/var/lib/grafana -v log:/var/log/grafana tcjennings/rpi-grafana" \
      org.label-schema.build-date="2016-10-24" \
      com.tobyjennings.base-image="resin/rpi-raspbian:jessie" \
      com.tobyjennings.architecture="arm6hf" 

RUN apt-get update \
 && apt-get install libfontconfig wget \
 && wget -O /tmp/grafana.deb https://github.com/tcjennings/raspberrypi-packages/raw/master/grafana/v3.1.1/grafana_3.1.1-1474584350_armhf.deb \
 && dpkg -i /tmp/grafana.deb \
 && apt-get clean \
 && rm -rf /tmp/* \

VOLUME /var/lib/grafana
VOLUME /var/log/grafana

EXPOSE 3000

ENV GF_PATHS_DATA /var/lib/grafana/
ENV GF_PATHS_LOGS /var/log/grafana/

ENTRYPOINT ["/usr/sbin/grafana-server"]
CMD ["-config","/etc/grafana/grafana.ini","-homepath","/usr/share/grafana"]

