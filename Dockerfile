ARG BIND9_VERSION=9.11.23

FROM alpine:3.12 as builder
ARG BIND9_VERSION
WORKDIR /tmp
# hadolint ignore=DL3003,DL3018
RUN apk update && apk add --no-cache alpine-sdk linux-headers && \
  wget https://downloads.isc.org/isc/bind9/${BIND9_VERSION}/bind-${BIND9_VERSION}.tar.gz && \
  tar xf bind-${BIND9_VERSION}.tar.gz && \
  cd bind-${BIND9_VERSION}/ && \
  CFLAGS="-static -O2" ./configure \
    --without-python \
    --without-openssl \
    --disable-symtable \
    --disable-threads \
    --disable-backtrace && \
  make && \
  strip --strip-all bin/dig/dig

FROM alpine:3.12
ARG BIND9_VERSION
COPY --from=builder /tmp/bind-${BIND9_VERSION}/bin/dig/dig /usr/local/bin/
CMD ["/bin/sh"]
