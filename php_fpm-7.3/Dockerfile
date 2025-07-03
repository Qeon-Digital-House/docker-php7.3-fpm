FROM php:7.3-fpm

WORKDIR /var/www/html

COPY docker-php-entrypoint get-composer.sh /usr/local/bin/
COPY runnables/*.sh /usr/local/runnables/

RUN echo "deb http://archive.debian.org/debian buster-backports main" > /etc/apt/sources.list.d/buster-backports.list \
    && apt-get update \
    && apt-get -y dist-upgrade \
    && apt-get -y install etcd-client vim curl unzip gnupg2 software-properties-common git \
                          ncat wait-for-it zlib1g-dev libzip-dev libicu-dev libbz2-dev liblz4-dev \
                          libpng-dev libwebp-dev libjpeg-dev libfreetype6-dev libpq-dev librdkafka-dev \
                          libgmp-dev libxslt1-dev liblzf-dev libzstd-dev mariadb-client postgresql-client \
    && apt-get -y autoremove \
    && apt-get autoclean \
    && apt-get clean \
    && docker-php-ext-configure gd --with-webp-dir --with-jpeg-dir --with-freetype-dir \
    && docker-php-ext-install bcmath calendar bz2 exif \
                              gd gettext gmp intl pcntl \
                              pdo_mysql shmop sockets \
                              sysvmsg sysvsem sysvshm \
                              xsl opcache zip pdo_pgsql \
    && pecl install igbinary msgpack \
    && pecl install --configureoptions "with-liblz4='yes' enable-redis='yes' enable-redis-igbinary='yes' \
                                        enable-redis-msgpack='yes' enable-redis-lzf='yes' enable-redis-zstd='yes' \
                                        enable-redis-lz4='yes'" \
       redis-6.0.2 \
    && pecl install --configureoptions "enable-mongodb-developer-flags='no' enable-mongodb-coverage='no' \
                                        with-mongodb-system-libs='no' with-mongodb-client-side-encryption='auto' \
                                        with-mongodb-snappy='auto' with-mongodb-zlib='auto' with-mongodb-zstd='auto' \
                                        with-mongodb-sasl='auto' with-mongodb-ssl='auto' \
                                        enable-mongodb-crypto-system-profile='no' enable-system-ciphers='no' \
                                        with-mongodb-utf8proc='bundled'" \
       mongodb-1.16.2 \
    && pecl install --configureoptions "with-rdkafka='yes'" rdkafka

RUN docker-php-ext-enable bcmath calendar bz2 exif \
                          gd gettext gmp intl pcntl \
                          pdo_mysql shmop sockets pdo_pgsql \
                          sysvmsg sysvsem sysvshm \
                          xsl opcache zip igbinary msgpack redis mongodb rdkafka \
    && mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini" \
    && chmod 755 /usr/local/bin/get-composer.sh /usr/local/bin/docker-php-entrypoint \
    && /usr/local/bin/get-composer.sh \
    && rm -fr /usr/local/bin/get-composer.sh \
    && rm -fr /tmp/pear \
    && rm -fr /var/cache/apt
