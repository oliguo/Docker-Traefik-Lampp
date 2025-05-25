FROM alpine:3.21

LABEL org.label-schema.name="alpine-apache-php8.3"
LABEL maintainer.name="Oliver Guo"
LABEL maintainer.email="oli.zd.guo@gmail.com"

COPY crontab.conf /opt/crontab.conf
COPY entry.sh /opt/entry.sh

RUN apk update && \
    apk upgrade && \
	apk add --no-cache \
	ffmpeg \
	nano \
	openssl \
	openssl-dev \
	tzdata \
	openntpd \
	curl \
	ca-certificates \
	git \
	gcc \
	musl-dev \
	make \
	redis \
	gnupg \
	openrc \
	apache2 \
    apache2-ssl \
    apache2-utils \
	apache2-error \
	php83-apache2 \
	php83 \
	php83-phar \
	php83-json \
	php83-iconv \
	php83-openssl \
	php83-curl \
	php83-intl \
	php83-ftp \
	php83-xdebug \
	php83-mbstring \
	php83-soap \
	php83-gmp \
	php83-pdo_odbc \
	php83-dom \
	php83-pdo \
	php83-zip \
	php83-mysqli \
	php83-sqlite3 \
	php83-pdo_pgsql \
	php83-bcmath \
	php83-gd \
	php83-odbc \
	php83-pdo_mysql \
	php83-pdo_sqlite \
	php83-gettext \
	php83-xmlreader \
	php83-xmlwriter \
	php83-tokenizer \
	php83-bz2 \
	php83-pdo_dblib \
	php83-curl \
	php83-ctype \
	php83-session \
	php83-redis \
	php83-exif \
	php83-imap \
	php83-pspell \
	php83-tidy \
	php83-xsl \
	php83-pear \
	php83-gettext \
	php83-apcu \
	php83-simplexml \
    php83-mysqlnd \
    php83-xml \
    php83-enchant \
    php83-bcmath \
    php83-sysvsem \
    php83-opcache \
    php83-posix \
    php83-zlib \
	php83-fileinfo \
	php83-dev \
	php83-pecl-imagick \
	php83-pecl-imagick-dev \
	php83-sodium
	
RUN pecl channel-update pecl.php.net
RUN pecl install mongodb

RUN curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer

RUN crond start

RUN rm -f /var/cache/apk/*
RUN rm -rf /tmp/*

RUN chmod 777 /opt/entry.sh

ENTRYPOINT ["/opt/entry.sh"]
