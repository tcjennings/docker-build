FROM resin/rpi-raspbian:jessie

ARG OLAVERSION=0.10.5
ARG configflags


LABEL org.label-schema.schema-version="1.0" \
      org.label-schema.name="openlighting" \
      org.label-schema.description="OpenLightingProject OLA" \
      org.label-schema.version="${OLAVERSION}" \
      org.label-schema.docker.cmd="" \
      org.label-schema.build-date="2017-08-22" \
      com.tobyjennings.base-image="resin/rpi-raspbian:jessie" \
      com.tobyjennings.architecture="arm7" 

RUN apt-get update \
 && apt-get upgrade -y \
 && apt-get install -y libcppunit-dev libcppunit-1.13-0 uuid-dev pkg-config libncurses5-dev libtool autoconf automake g++ libmicrohttpd-dev libmicrohttpd10 protobuf-compiler libprotobuf-lite9 python-protobuf libprotobuf-dev libprotoc-dev zlib1g-dev bison flex make libftdi-dev libftdi1 libusb-1.0-0-dev liblo-dev libavahi-client-dev python-numpy git openjdk-8-jdk maven devscripts fakeroot build-essential debhelper dh-autoreconf bash-completion

RUN groupadd olabuild \
 && useradd -s /bin/bash -g olabuild olabuild 

USER olabuild:olabuild

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

CMD ["tail","-f","/dev/null"]
