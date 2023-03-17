FROM php:7.4-fpm

WORKDIR /var/www/html

COPY docker-php-entrypoint get-composer.sh /usr/local/bin/
COPY runnables/*.sh /usr/local/runnables/

RUN apt-get update \
    && apt-get -y dist-upgrade \
    && apt-get -y install etcd-client vim curl unzip gnupg2 software-properties-common git \
                          ncat wait-for-it zlib1g-dev libzip-dev libicu-dev libbz2-dev \
                          libpng-dev libwebp-dev libjpeg-dev libfreetype-dev libgmp-dev \
                          libxslt1-dev liblzf-dev libzstd-dev mariadb-client \
    && apt-get -y autoremove \
    && apt-get autoclean \
    && apt-get clean \
    && docker-php-ext-configure gd --with-webp --with-jpeg --with-freetype \
    && docker-php-ext-install bcmath calendar bz2 exif \
                              gd gettext gmp intl pcntl \
                              pdo_mysql shmop sockets \
                              sysvmsg sysvsem sysvshm \
                              xsl opcache zip \
    && pecl install igbinary

RUN yes | pecl install redis

RUN docker-php-ext-enable bcmath calendar bz2 exif \
                          gd gettext gmp intl pcntl \
                          pdo_mysql shmop sockets \
                          sysvmsg sysvsem sysvshm \
                          xsl opcache zip igbinary redis \
    && mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini" \
    && chmod 755 /usr/local/bin/get-composer.sh /usr/local/bin/docker-php-entrypoint \
    && /usr/local/bin/get-composer.sh \
    && rm -fr /usr/local/bin/get-composer.sh
