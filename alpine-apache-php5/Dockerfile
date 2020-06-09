FROM alpine:3.6.5

LABEL org.label-schema.name="alpine-apache-php5"

RUN echo "@edge-main http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories && \
	echo "@edge-community http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
	echo "@edge-testing http://dl-4.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
	apk update && \
    apk upgrade && \
	apk add --no-cache \
	nano \
	openssl \
	tzdata \
	openntpd \
	curl \
	ca-certificates \
	git \
	apache2 \
    apache2-ssl \
    apache2-utils \
	apache2-error \
	php5-apache2 \
	php5 \
	php5-common \
	php5-dba \
	php5-phpdbg \
	php5-pcntl \
	php5-fpm \
	php5-phar \
	php5-json \
	php5-iconv \
	php5-openssl \
	php5-curl \
	php5-intl \
	php5-ftp \
	php5-mcrypt \
	php5-soap \
	php5-gmp \
	php5-pdo_odbc \
	php5-dom \
	php5-pdo \
	php5-zip \
	php5-mysql \
	php5-mysqli \
	php5-sqlite3 \
	php5-pgsql \
	php5-pdo_pgsql \
	php5-bcmath \
	php5-gd \
	php5-odbc \
	php5-pdo_mysql \
	php5-pdo_sqlite \
	php5-gettext \
	php5-xmlreader \
	php5-xmlrpc \
	php5-bz2 \
	php5-pdo_dblib \
	php5-curl \
	php5-ctype \
	php5-exif \
	php5-imap \
	php5-pspell \
	php5-xsl \
	php5-pear \
	php5-gettext \
    php5-xml \
    php5-enchant \
    php5-bcmath \
    php5-sysvsem \
    php5-opcache \
    php5-posix \
    php5-zlib \
    php5-snmp \
    php5-doc \
    php5-dev \
    php5-embed \
    php5-ldap \
    php5-shmop \
    php5-cgi \
    php5-wddx \
    php5-calendar \
    php5-sockets \
    php5-sysvmsg \
    imagemagick-dev

RUN cp /usr/bin/php5 /usr/bin/php && \
    mkdir -p /run/apache2

RUN curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer

RUN rm -f /var/cache/apk/*
RUN rm -rf /tmp/*

ENTRYPOINT ["httpd", "-D", "FOREGROUND"]
