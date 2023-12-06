FROM composer:2.3 as composer

FROM ghcr.io/nulldark/alpine:latest

LABEL org.opencontainers.image.title="php"
LABEL org.opencontainers.image.description="php docker container image"
LABEL org.opencontainers.image.url=https://github.com/nulldark/php
LABEL org.opencontainers.image.source=https://github.com/nulldark/php
LABEL org.opencontainers.image.authors="Dominik Szamburski <dominikszamburski99@gmai.com>"
LABEL org.opencontainers.image.vendor="nulldark"
LABEL org.opencontainers.image.licenses="MIT"

ARG PHP_USER_ID=1000
ARG PHP_GROUP_ID=1000
ARG PHP_FPM_PORT=9000

ENV PHP_USER_ID=${PHP_USER_ID}
ENV PHP_GROUP_ID=${PHP_GROUP_ID}
ENV PHP_FPM_PORT=${PHP_FPM_PORT}

RUN apk add --update --no-cache shadow; \
    groupadd -g "${PHP_GROUP_ID}" application; \
	useradd  -u "${PHP_USER_ID}" -m -s /bin/bash -g application application; \
	adduser application www-data;

RUN apk add ca-certificates && \
    echo 'https://dl-cdn.alpinelinux.org/alpine/edge/testing' >> /etc/apk/repositories && \
    apk add --update-cache \
        php82-curl \
        php82-dom \
        php82-mbstring \
        php82-mysqli \
        php82-pdo \
        php82-pdo_pgsql \
        php82-pdo_mysql \
        php82-pgsql \
        php82-phar \
        php82-redis \
        php82-simplexml \
        php82-tokenizer \
        php82-xml \
        php82-xmlwriter \
        php82-fpm \
        php82 \
    && ln -s /usr/bin/php82 /usr/bin/php && ln -s /usr/bin/php-fpm82 /usr/bin/php-fpm

RUN sed -e 's;/bin/ash$;/bin/bash;g' -i /etc/passwd

COPY ./conf.d/ /etc/php8/conf.d/
COPY ./php-fpm.d/ /etc/php8/php-fpm.d/

COPY --from=composer /usr/bin/composer /usr/local/bin/composer

RUN sed -i "s#listen = 0.0.0.0:__PHP_FPM_PORT__#listen = 0.0.0.0:$PHP_FPM_PORT;#" /etc/php8/php-fpm.d/www.conf

ARG PHP_XDEBUG=false
ENV PHP_XDEBUG=${PHP_XDEBUG}

RUN if [ ${PHP_XDEBUG} = true ]; then \
  apk add --update-cache --update \
    php82-xdebug \
;fi

EXPOSE 9000

CMD ["php-fpm", "-F"]


