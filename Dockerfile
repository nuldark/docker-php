FROM ghcr.io/nulldark/alpine

LABEL org.opencontainers.image.title="php-fpm"
LABEL org.opencontainers.image.description="php fpm docker container image"
LABEL org.opencontainers.image.url=https://github.com/nulldark/php-fpm
LABEL org.opencontainers.image.source=https://github.com/nulldark/php-fpm
LABEL org.opencontainers.image.authors="Dominik Szamburski <dominikszamburski99@gmai.com>"
LABEL org.opencontainers.image.vendor="nulldark"
LABEL org.opencontainers.image.licenses="MIT"

ENV PHP_VERSION 8.3.2
ENV PHP_URL="https://www.php.net/distributions/php-$PHP_VERSION.tar.xz"
ENV PHP_ASC_URL="https://www.php.net/distributions/php-$PHP_VERSION.tar.xz.asc"
ENV CHECKSUM="4ffa3e44afc9c590e28dc0d2d31fc61f0139f8b335f11880a121b9f9b9f0634e"

ENV PHP_PREFIX_HOME /usr/local
ENV PHP_SBIN_DIR "$PHP_PREFIX_HOME/bin"
ENV PHP_INI_DIR "/usr/local/etc/php"
ENV PHP_SCAN_DIR "$PHP_INI_DIR/conf.d"

# Gets PHP sources and checking the checksum
ENV GPG_KEYS 1198C0117593497A5EC5C199286AF1F9897469DC C28D937575603EB4ABB725861C0779DC5C0A9DE4 AFD8691FDAEDF03BDF6E460563F15A9B715376CA

ENV PHP_CFLAGS="-fstack-protector-strong -fpic -fpie -O3 \
    -D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 \
    -march=native \
    -funroll-loops \
    -ffast-math \
    -finline-functions \
"

ENV PHP_CPPFLAGS="$PHP_CFLAGS"
ENV PHP_LDFLAGS="-Wl,-O3 -pie"

RUN set -eux; \
    adduser -u 82 -D -S -G www-data www-data; \
    mkdir -p "$PHP_SCAN_DIR"; \
    [ ! -d /var/www/html ]; \
    mkdir -p /var/www/html; \
    chown www-data:www-data /var/www/html; \
    chmod 1777 /var/www/html; \
    \
	apk add --no-cache --virtual .fetch-deps gnupg curl; \
	\
	mkdir -p /usr/src; \
	cd /usr/src; \
    \
    curl -fsSL -o php.tar.xz "$PHP_URL"; \
    \
    if [ -n "$CHECKSUM" ]; then \
        echo "$CHECKSUM *php.tar.xz" | sha256sum -c -; \
    fi; \
    \
    if [ -n "$PHP_ASC_URL" ]; then \
        curl -fsSL -o php.tar.xz.asc "$PHP_ASC_URL"; \
        export GNUPGHOME="$(mktemp -d)"; \
        for key in $GPG_KEYS; do \
			gpg --batch --keyserver keyserver.ubuntu.com --recv-keys "$key"; \
		done; \
		gpg --batch --verify php.tar.xz.asc php.tar.xz; \
		gpgconf --kill all; \
		rm -rf "$GNUPGHOME"; \
    fi; \
    \
    apk del --no-network .fetch-deps ; \
    \
    apk add --update --no-cache --virtual=.build-deps \
        # required deps for build
        autoconf \
        dpkg dpkg-dev \
        file \
        clang \
        llvm \
        libc-dev \
        make \
        pkgconf \
        re2c \
        #deps for exts
        argon2-dev \
		coreutils \
		curl-dev \
		gnu-libiconv-dev \
		libsodium-dev \
		libxml2-dev \
		linux-headers \
		oniguruma-dev \
		openssl-dev \
		readline-dev \
		# gd
		freetype-dev libpng-dev jpeg-dev libjpeg-turbo-dev libwebp-dev libavif-dev \
		# pqsql
		libpq-dev \
		# intl
		icu-dev \
		sqlite-dev; \
    rm -vf /usr/include/iconv.h; \
    \
    export \
		CFLAGS="$PHP_CFLAGS" \
		CPPFLAGS="$PHP_CPPFLAGS" \
		LDFLAGS="$PHP_LDFLAGS" \
		PHP_BUILD_PROVIDER='https://github.com/nulldark/php' \
		PHP_UNAME='Linux - Docker' \
	; \
	\
	mkdir -p /usr/src/php; \
	tar -Jxf /usr/src/php.tar.xz -C /usr/src/php --strip-components=1; \
	rm -rf /usr/src/php.tar.*; \
	\
    cd /usr/src/php; \
    \
   ./configure \
        # sets clang compiler
        CC=clang CXX=clang++ \
        # config
        --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
        --prefix="$PHP_PREFIX_HOME" \
        --sbindir="$PHP_SBIN_DIR" \
        --sysconfdir="$PHP_INI_DIR" \
        --localstatedir=/var \
        --mandir=/usr/share/man \
        --with-layout=GNU \
        --with-config-file-path="$PHP_INI_DIR" \
        --with-config-file-scan-dir="$PHP_SCAN_DIR" \
        # flags
        --config-cache \
        --enable-option-checking=fatal \
        --disable-gcc-global-regs \
        --disable-rpath \
        # ftp
        #--enable-ftp \
        # mbstring
        --enable-mbstring \
        # iconv
        --with-iconv=/usr \
        # sqlite
        --with-sqlite3=/usr \
        --with-pdo-sqlite=/usr \
        # mhash
        --with-mhash \
        # pic
        --with-pic \
        # OpenSSL
		--with-openssl \
		# readline
		--with-readline \
        # zlib
        --with-zlib \
        # cURL
		--with-curl \
		# pear
		--with-pear \
        # argon2
        --with-password-argon2 \
        #-- gd \
        #--enable-gd \
        #--with-freetype=/usr/lib/ \
        #--with-jpeg=/usr/lib/ \
        #--with-avif \
        #--with-webp \
        #--intl \
        #--enable-intl \
        # pdo-mysql \
        --with-pdo-mysql \
        # pdo-pgsql \
        --with-pdo-pgsql \
        # soap
        #--enable-soap \
        #--with-libxml \
        # sodium
        #--with-sodium \
        # sockets
        #--enable-sockets \
        # fpm \
        --disable-cgi \
        --enable-fpm \
		--with-fpm-user=www-data \
		--with-fpm-group=www-data \
		# phpdbg
		--disable-phpdbg \
		; \
    \
    make -j $(nproc); \
    find -type f -name '*.a'; \
    make install; \
	find \
		/usr \
		-type f \
		-perm '/0111' \
		-exec sh -euxc ' \
			strip --strip-all "$@" || : \
		' -- '{}' + \
	; \
    make clean; \
    cp -v php.ini-production "$PHP_INI_DIR/php.ini"; \
    \
    cd /; \
    rm -rf /usr/src/php; \
    \
      runDeps="$( \
    		scanelf --needed --nobanner --format '%n#p' --recursive /usr/local \
    			| tr ',' '\n' \
    			| sort -u \
    			| awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
    	)";  \
    \
	apk add --no-cache $runDeps; \
    \
    apk del --no-network .build-deps ; \
    \
    pecl update-channels; \
    rm -rf /tmp/pear ~/.pearrc; \
    \
    php --version; \
    \
    cd /usr/local/etc/php; \
    cp php-fpm.conf.default php-fpm.conf; \
    if [ -d php-fpm.d ]; then \
        sed 's!=NONE/!=!g' php-fpm.conf.default | tee php-fpm.conf > /dev/null; \
		cp php-fpm.d/www.conf.default php-fpm.d/www.conf; \
	fi


WORKDIR /var/www/html

STOPSIGNAL SIGQUIT

EXPOSE 9000
CMD ["php-fpm", "-F"]
