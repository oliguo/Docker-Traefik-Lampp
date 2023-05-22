FROM alpine:3.15

LABEL org.label-schema.name="alpine-apache-php7"
LABEL maintainer.name="Oliver Guo"
LABEL maintainer.email="oli.zd.guo@gmail.com"

COPY crontab.conf /opt/crontab.conf
COPY entry.sh /opt/entry.sh

RUN apk update && \
    apk upgrade && \
	apk add --no-cache \
	nano \
	autoconf \
	make \
	g++ \
	unixodbc-dev \
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
	php7-apache2 \
	php7 \
	php7-dev \
	php7-phar \
	php7-json \
	php7-iconv \
	php7-openssl \
	php7-curl \
	php7-intl \
	php7-ftp \
	php7-xdebug \
	php7-mcrypt \
	php7-mbstring \
	php7-soap \
	php7-gmp \
	php7-pdo_odbc \
	php7-dom \
	php7-pdo \
	php7-zip \
	php7-mysqli \
	php7-sqlite3 \
	php7-pdo_pgsql \
	php7-bcmath \
	php7-gd \
	php7-odbc \
	php7-pdo_mysql \
	php7-pdo_sqlite \
	php7-gettext \
	php7-xmlreader \
	php7-xmlwriter \
	php7-tokenizer \
	php7-xmlrpc \
	php7-bz2 \
	php7-pdo_dblib \
	php7-curl \
	php7-ctype \
	php7-session \
	php7-redis \
	php7-exif \
	php7-imap \
	php7-pspell \
	php7-tidy \
	php7-xsl \
	php7-imagick \
	php7-pear \
	php7-gettext \
	php7-apcu \
	php7-simplexml \
    php7-mysqlnd \
    php7-xml \
    php7-enchant \
    php7-bcmath \
    php7-sysvsem \
    php7-opcache \
    php7-posix \
    php7-zlib \
	php7-fileinfo \
	php7-dev \
	gcc \
	musl-dev \
	make
	
RUN pecl channel-update pecl.php.net
RUN pecl install sqlsrv-5.10.1 \
	pecl install pdo_sqlsrv-5.10.1 \
	pecel install mongodb

RUN curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer

RUN crond start

RUN rm -f /var/cache/apk/*
RUN rm -rf /tmp/*

RUN chmod 777 /opt/entry.sh

ENTRYPOINT ["/opt/entry.sh"]
