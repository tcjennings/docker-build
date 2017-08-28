FROM resin/rpi-raspbian:jessie

ARG OLAVERSION=0.10.5

LABEL org.label-schema.schema-version="1.0" \
      org.label-schema.name="openlighting" \
      org.label-schema.description="OpenLightingProject OLA" \
      org.label-schema.version="${OLAVERSION}" \
      org.label-schema.docker.cmd="docker run -itd -P -v /path/to/conf:/etc/olad <image>" \
      org.label-schema.build-date="2017-08-22" \
      com.tobyjennings.base-image="resin/rpi-raspbian:jessie" \
      com.tobyjennings.architecture="arm7" 

RUN apt-get update \
 && apt-get upgrade -y \
 && apt-get install -y wget libprotobuf9 libftdi1 libcppunit-1.13-0 libprotobuf-lite9 uuid libmicrohttpd10 liblo7 libusb-1.0-0 python-numpy libjs-jquery-ui python-protobuf \
 && cd /tmp \
 && wget https://github.com/tcjennings/raspberrypi-packages/raw/master/ola/${OLAVERSION}/ola_${OLAVERSION}-1_armhf.deb \
 && wget https://github.com/tcjennings/raspberrypi-packages/raw/master/ola/${OLAVERSION}/ola-rdm-tests_${OLAVERSION}-1_all.deb \
 && wget https://github.com/tcjennings/raspberrypi-packages/raw/master/ola/${OLAVERSION}/libola1_${OLAVERSION}-1_armhf.deb \
 && wget https://github.com/tcjennings/raspberrypi-packages/raw/master/ola/${OLAVERSION}/ola-python_${OLAVERSION}-1_all.deb \
 && dpkg -i /tmp/libola1_${OLAVERSION}-1_armhf.deb \
 && dpkg -i /tmp/ola_${OLAVERSION}-1_armhf.deb \
 && dpkg -i /tmp/ola-python_${OLAVERSION}-1_all.deb \
 && dpkg -i /tmp/ola-rdm-tests_${OLAVERSION}-1_all.deb \
 && apt-get clean \
 && rm -rf /tmp/* \
 && mkdir -p /etc/olad

EXPOSE 9090 9010

ADD ola-conf.tar /etc/olad/
COPY ola_conf_plugins.sh /usr/bin/

VOLUME /etc/olad

ENTRYPOINT ["olad","-l","3","-c","/etc/olad","-i","0.0.0.0"]

