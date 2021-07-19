FROM elixir:1.12-alpine

ARG apk_mirror=dl-cdn.alpinelinux.org
ARG hex_mirror=https://repo.hex.pm

RUN sed -i \
  s/dl-cdn.alpinelinux.org/$apk_mirror/g \
  /etc/apk/repositories

RUN apk update --no-cache && \
  apk add --no-cache \
    bash \
    nodejs \
    yarn \
    npm \
    git \
    libpng \
    libpng-dev \
    alpine-sdk \
    coreutils \
    tzdata \
    openssl-dev \
    libjpeg-turbo-utils \
    pngquant \
    docker

# Glibc for NIF applications
# @see https://docs.appsignal.com/elixir/why-nif.html
# @see https://github.com/jeanblanchard/docker-alpine-glibc/blob/master/Dockerfile
ENV GLIBC_VERSION 2.30-r0

RUN apk add --update curl && \
  curl -sSLo /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub && \
  curl -sSLo glibc.apk "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk" && \
  curl -sSLo glibc-bin.apk "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-bin-${GLIBC_VERSION}.apk" && \
  apk add glibc-bin.apk glibc.apk && \
  /usr/glibc-compat/sbin/ldconfig /lib /usr/glibc-compat/lib && \
  rm -rf glibc.apk glibc-bin.apk /var/cache/apk/

ENV HEX_MIRROR $hex_mirror

RUN mix local.hex --force
RUN mix local.rebar --force

RUN mkdir -p /root/.config/rebar3 && \
  echo '{plugins, [rebar3_hex]}.' > /root/.config/rebar3/rebar.config

RUN /root/.mix/rebar3 plugins upgrade rebar3_hex
