FROM ghcr.io/nulldark/alpine:edge

LABEL org.opencontainers.image.title="php"
LABEL org.opencontainers.image.description="php docker container image"
LABEL org.opencontainers.image.url=https://github.com/nulldark/php
LABEL org.opencontainers.image.source=https://github.com/nulldark/php
LABEL org.opencontainers.image.authors="Dominik Szamburski <dominikszamburski99@gmai.com>"
LABEL org.opencontainers.image.vendor="nulldark"
LABEL org.opencontainers.image.licenses="MIT"

RUN set -xe; \
    apk add --update --no-cache --virtual=.build-deps \
        re2c \
        bison \
        autoconf \
        make \
        libtool \
        ccache \
        libxml2-dev \
        sqlite-dev; \
    && apk del .build-deps


