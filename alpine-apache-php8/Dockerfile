FROM alpine:3.22

LABEL org.label-schema.name="alpine-apache-php8.5"
LABEL maintainer.name="Oliver Guo"
LABEL maintainer.email="oli.zd.guo@gmail.com"

COPY crontab.conf /opt/crontab.conf
COPY entry.sh /opt/entry.sh

RUN apk update && \
    apk upgrade && \
    apk add --no-cache \
    --repository=https://dl-cdn.alpinelinux.org/alpine/edge/main \
    --repository=https://dl-cdn.alpinelinux.org/alpine/edge/community \
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
    imap-dev \
    krb5-dev \
    aspell-dev \
    php85-apache2 \
    php85 \
    php85-phar \
    php85-json \
    php85-iconv \
    php85-openssl \
    php85-curl \
    php85-intl \
    php85-ftp \
    php85-xdebug \
    php85-mbstring \
    php85-soap \
    php85-gmp \
    php85-pdo_odbc \
    php85-dom \
    php85-pdo \
    php85-zip \
    php85-mysqli \
    php85-sqlite3 \
    php85-pdo_pgsql \
    php85-bcmath \
    php85-gd \
    php85-odbc \
    php85-pdo_mysql \
    php85-pdo_sqlite \
    php85-gettext \
    php85-xmlreader \
    php85-xmlwriter \
    php85-tokenizer \
    php85-bz2 \
    php85-pdo_dblib \
    php85-ctype \
    php85-session \
    php85-redis \
    php85-exif \
    php85-tidy \
    php85-xsl \
    php85-pear \
    php85-apcu \
    php85-simplexml \
    php85-mysqlnd \
    php85-xml \
    php85-enchant \
    php85-sysvsem \
    php85-posix \
    php85-zlib \
    php85-fileinfo \
    php85-dev \
    php85-pecl-imagick \
    php85-pecl-imagick-dev \
    php85-sodium

# 為了避免 PECL 安裝 imap 時卡在詢問 (prompt) 環節，這裡可以加上 yes 指令自動同意預設選項
RUN pecl85 channel-update pecl.php.net
RUN pecl85 install mongodb
RUN yes "" | pecl85 install imap pspell
RUN echo "extension=imap.so" > /etc/php85/conf.d/imap.ini
RUN echo "extension=pspell.so" > /etc/php85/conf.d/pspell.ini
RUN echo "extension=mongodb.so" > /etc/php85/conf.d/mongodb.ini

RUN COMPOSER_IPRESOLVE=4 curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer

RUN crond start

RUN rm -f /var/cache/apk/*
RUN rm -rf /tmp/*

RUN chmod 777 /opt/entry.sh

ENTRYPOINT ["/opt/entry.sh"]