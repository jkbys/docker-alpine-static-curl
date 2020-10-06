ARG BIND9_VERSION=9.16.7

FROM alpine:3.12 as builder
ARG BIND9_VERSION
WORKDIR /tmp
# hadolint ignore=DL3003,DL3018
RUN apk update && \
  apk add --no-cache alpine-sdk linux-headers libuv-dev libuv-static openssl-dev openssl-libs-static && \
  wget https://downloads.isc.org/isc/bind9/${BIND9_VERSION}/bind-${BIND9_VERSION}.tar.xz && \
  tar xf bind-${BIND9_VERSION}.tar.xz && \
  cd bind-${BIND9_VERSION}/ && \
  CFLAGS="-static -O2" ./configure \
    --without-python \
    --disable-symtable \
    --disable-backtrace \
    --disable-linux-caps && \
  cd lib/dns/ && \
  make && \
  cd ../bind9/ && \
  make && \
  cd ../isc && \
  make && \
  cd ../isccfg/ && \
  make && \
  cd ../irs/ && \
  make && \
  cd ../../bin/dig && \
  make && \
  strip --strip-all dig && \
  ./dig

FROM alpine:3.12
ARG BIND9_VERSION
COPY --from=builder /tmp/bind-${BIND9_VERSION}/bin/dig/dig /usr/local/bin/
CMD ["/bin/sh"]
