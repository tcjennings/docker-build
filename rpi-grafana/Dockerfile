ARG node_version=9.8.0
ARG node_architecture=armv7l

FROM resin/rpi-raspbian:latest as builder

RUN buildDeps='curl gcc g++ git libsqlite3-0 libfontconfig1 libicu52 python2.7 make ruby ruby-dev adduser' \
	&& set -x \
	&& apt-get update && apt-get install -y $buildDeps \
        && ln -s /usr/bin/python2.7 /usr/bin/python2 \
        && gem install fpm \
	&& rm -rf /var/lib/apt/lists/*

ARG node_version=9.8.0
ARG node_architecture=armv7l
RUN set -x \
 && curl -Lk https://nodejs.org/dist/v${node_version}/node-v${node_version}-linux-${node_architecture}.tar.xz \
  | tar -xJvf - --strip-components=1 -C /usr/local/

RUN curl -Lk https://raw.githubusercontent.com/timstanley1985/phantomjs-linux-armv6l/master/phantomjs-2.1.1-linux-armv6l.tar.gz \
  | tar xzf - -C /usr/local --strip-components=1 --no-same-permissions --no-same-owner

ENV GOROOT /usr/local/go
ENV GOPATH /go
ENV GOOS linux
ENV GOARCH arm
ENV GO_VERSION 1.9.2

RUN mkdir -p /usr/local/go \
	&& curl -SLO "https://dl.google.com/go/go${GO_VERSION}.${GOOS}-armv6l.tar.gz" \
	&& tar -xzf "go$GO_VERSION.${GOOS}-armv6l.tar.gz" -C /usr/local/go --strip-components=1 \
	&& rm -f go$GO_VERSION.${GOOS}-armv6l.tar.gz \
        && mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"

ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH
ENV NODE=/usr/local/bin/node
ENV NPM=/usr/local/bin/npm

WORKDIR $GOPATH

ARG grafana_ver=5.0.3
RUN go get -d github.com/grafana/grafana \
 || cd $GOPATH/src/github.com/grafana/grafana \
 && git checkout v${grafana_ver}

WORKDIR $GOPATH/src/github.com/grafana/grafana

RUN go run build.go setup
RUN go run build.go build
RUN $NPM install -g yarn
RUN yarn install --pure-lockfile
#RUN $NPM run watch
#RUN $NPM run jest
#RUN $NPM run karma
RUN go run build.go pkg-deb
RUN ls -l /go/src/github.com/grafana/grafana/dist

FROM resin/rpi-raspbian:latest as runtime
ARG grafana_ver=5.0.3
COPY --from=builder /go/src/github.com/grafana/grafana/dist/grafana_${grafana_ver}-*_armhf.deb /tmp/grafana.deb
RUN apt-get update \
 && apt-get install -y libfontconfig \
 && dpkg -i /tmp/grafana.deb \
 && apt-get clean \
 && rm -rf /tmp/* \
 && rm -rf /var/lib/apt/lists/*

VOLUME /var/lib/grafana
VOLUME /var/log/grafana

EXPOSE 3000

ENV GF_PATHS_DATA /var/lib/grafana/
ENV GF_PATHS_PLUGINS /var/lib/grafana/plugins
ENV GF_PATHS_LOGS /var/log/grafana/

LABEL org.label-schema.schema-version="1.0" \
      org.label-schema.name="grafana" \
      org.label-schema.description="Grafana" \
      org.label-schema.version="${grafana_ver}" \
      org.label-schema.docker.cmd="docker run -d -p 3000:3000 -v data:/var/lib/grafana -v log:/var/log/grafana tcjennings/rpi-grafana" \
      org.label-schema.build-date="2018-03-19" \
      com.tobyjennings.base-image="resin/rpi-raspbian:jessie" \
      com.tobyjennings.architecture="arm6hf"

ENTRYPOINT ["/usr/sbin/grafana-server"]
CMD ["-config","/etc/grafana/grafana.ini","-homepath","/usr/share/grafana"]

