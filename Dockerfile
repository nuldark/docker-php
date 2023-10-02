ARG PHP_VERSION=8.3.0RC3-fpm
FROM php:${PHP_VERSION}

COPY ./conf.d/php.ini /usr/local/etc/php/conf.d
COPY ./php-fpm.d/www.conf /usr/local/etc/php-fpm.d/

RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    rm -f /var/log/lastlog /var/log/faillog

ARG APP_USER_ID=1000
ENV APP_USER_ID ${APP_USER_ID}

ARG APP_GROUP_ID=1000
ENV APP_GROUP_ID ${APP_GROUP_ID}

RUN groupmod -o -g ${APP_GROUP_ID} www-data && \
    usermod -o -u ${APP_USER_ID} -g www-data www-data

WORKDIR /var/www

CMD ["php-fpm"]

EXPOSE 9000