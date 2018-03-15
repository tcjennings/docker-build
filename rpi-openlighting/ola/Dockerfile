FROM resin/rpi-raspbian:jessie as builder

ARG OLAVERSION=0.10.6
ARG configflags

RUN apt-get update \
 && apt-get upgrade -y \
 && apt-get install -y libcppunit-dev libcppunit-1.13-0 uuid-dev pkg-config libncurses5-dev libtool autoconf automake g++ libmicrohttpd-dev libmicrohttpd10 protobuf-compiler libprotobuf-lite9 python-protobuf libprotobuf-dev libprotoc-dev zlib1g-dev bison flex make libftdi-dev libftdi1 libusb-1.0-0-dev liblo-dev libavahi-client-dev python-numpy git openjdk-8-jdk maven devscripts fakeroot build-essential debhelper dh-autoreconf bash-completion

RUN groupadd olabuild \
 && useradd -s /bin/bash -g olabuild olabuild \
 && mkdir /opt/ola \
 && mkdir -p /home/olabuild \
 && chown olabuild:olabuild /opt/ola \
 && chown olabuild:olabuild /home/olabuild

#USER olabuild:olabuild

RUN cd /opt \
 && git clone https://github.com/OpenLightingProject/ola.git ola \
 && cd ola \
 && git checkout ${OLAVERSION} \
 && autoreconf -i \
 && ./configure --help 

WORKDIR /opt/ola

ENV CONFIGFLAGS="--disable-doxygen-doc --disable-doxygen-dot --enable-python-libs --enable-java-libs --without-dns-sd --disable-root-check ${configflags}" \
    DEB_BUILD_OPTIONS=nocheck

RUN ./configure ${CONFIGFLAGS} \
 && make dist

RUN cd /tmp \
 && tar xzf /opt/ola/ola-${OLAVERSION}.tar.gz \
 && cd ola-${OLAVERSION} \
 && sed -i "s/dh_auto_configure -- \(.*\)/dh_auto_configure -- \1 ${CONFIGFLAGS}/" debian/rules \
 && debuild -i -b -us -uc

RUN find /tmp -name "*.deb"

FROM resin/rpi-raspbian:jessie as runtime
ARG OLAVERSION=0.10.6
COPY --from=builder /tmp/*.deb /tmp/
RUN apt-get update \
 && apt-get upgrade -y \
 && apt-get install -y wget libprotobuf9 libftdi1 libcppunit-1.13-0 libprotobuf-lite9 uuid libmicrohttpd10 liblo7 libusb-1.0-0 python-numpy libjs-jquery-ui python-protobuf \
 && dpkg -i /tmp/libola1_${OLAVERSION}-1_armhf.deb \
 && dpkg -i /tmp/ola_${OLAVERSION}-1_armhf.deb \
 && dpkg -i /tmp/ola-python_${OLAVERSION}-1_all.deb \
 && dpkg -i /tmp/ola-rdm-tests_${OLAVERSION}-1_all.deb \
 && apt-get clean \
 && rm -rf /tmp/* \
 && rm -rf /var/lib/apt/lists/* \
 && mkdir -p /etc/olad
ADD ola-conf.tar /etc/olad/
COPY ola_conf_plugins.sh /usr/bin/

FROM scratch
ARG OLAVERSION=0.10.6
LABEL org.label-schema.schema-version="1.0" \
      org.label-schema.name="openlighting" \
      org.label-schema.description="OpenLightingProject OLA" \
      org.label-schema.version="${OLAVERSION}" \
      org.label-schema.docker.cmd="docker run -itd -P -v /path/to/conf:/etc/olad <image>" \
      org.label-schema.build-date="2018-01-30" \
      com.tobyjennings.base-image="resin/rpi-raspbian:jessie" \
      com.tobyjennings.architecture="arm7"

COPY --from=runtime / /
EXPOSE 9090 9010
VOLUME /etc/olad
ENTRYPOINT ["olad","-l","3","-c","/etc/olad","-i","0.0.0.0"]
