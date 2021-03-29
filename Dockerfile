FROM php:7.3-fpm

COPY docker-php-entrypoint get-composer.sh /usr/local/bin/
COPY runnables/*.sh /usr/local/runnables/

RUN apt-get update \
    && apt-get -y upgrade \
    && apt-get -y install etcd-client \
    && apt-get -y autoremove \
    && docker-php-ext-install bcmath \
    && chmod 755 /usr/local/bin/get-composer.sh docker-php-entrypoint \
    && /usr/local/bin/get-composer.sh
