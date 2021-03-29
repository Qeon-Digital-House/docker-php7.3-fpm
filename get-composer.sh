#!/bin/bash
# freely modified from https://getcomposer.org/doc/faqs/how-to-install-composer-programmatically.md
pushd /tmp > /dev/null
EXPECTED_CHECKSUM="$(php -r 'copy("https://composer.github.io/installer.sig", "php://stdout");')"
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
ACTUAL_CHECKSUM="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"

if [ "$EXPECTED_CHECKSUM" != "$ACTUAL_CHECKSUM" ]; then
    >&2 echo "Invalid composer setup."
    rm -fr composer-setup.php
    exit 1
fi

# specify our install dir to /usr/local/bin
php composer-setup.php --install-dir=/usr/local/bin --quiet
RET=$?
rm -fr composer-setup.php

# don't forget to soft-link composer to composer.phar
ln -s /usr/local/bin/composer.phar /usr/local/bin/composer
popd > /dev/null

exit $RET
