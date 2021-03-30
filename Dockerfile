FROM php:7.3-fpm

COPY docker-php-entrypoint get-composer.sh /usr/local/bin/
COPY runnables/*.sh /usr/local/runnables/

RUN apt-get update \
    && apt-get -y upgrade \
    && apt-get -y install etcd-client zlib1g-dev vim libzip-dev libicu-dev \
    && apt-get -y autoremove \
    && docker-php-ext-install bcmath \
    && docker-php-ext-install zip \
    && docker-php-ext-install sockets \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install intl \
    && chmod 755 /usr/local/bin/get-composer.sh /usr/local/bin/docker-php-entrypoint \
    && /usr/local/bin/get-composer.sh
