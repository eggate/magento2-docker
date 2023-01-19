#!/bin/bash

[ "$DEBUG" = "true" ] && set -x

PHP_EXT_DIR=/usr/local/etc/php/conf.d

# Enable PHP extensions
PHP_EXT_COM_ON=docker-php-ext-enable

[ -d ${PHP_EXT_DIR} ] && rm -f ${PHP_EXT_DIR}/docker-php-ext-*.ini

if [ -x "$(command -v ${PHP_EXT_COM_ON})" ] && [ ! -z "${PHP_EXTENSIONS}" ]; then
  ${PHP_EXT_COM_ON} ${PHP_EXTENSIONS}
fi

HOST_NAME="magento2.local"
HOST_IP=$(php -r "putenv('RES_OPTIONS=retrans:1 retry:1 timeout:1 attempts:1'); echo gethostbyname('$HOST_NAME');")
if [[ "$HOST_IP" == "$HOST_NAME" ]]; then
  HOST_IP=$(/sbin/ip route|awk '/default/ { print $3 }')
  printf "\n%s %s\n" "$HOST_IP" "$HOST_NAME" >> /etc/hosts
fi
/var/www/html/bin/magento setup:install --base-url=http://magento2.local --backend-frontname=admin --language=en_US --timezone=Asia/Dubai --currency=AED --db-host=db --db-name=magento --db-user=magento --db-password=magento --use-secure=0 --base-url-secure=https://magento2.local --use-secure-admin=0 --admin-firstname=Ahmed --admin-lastname=Allam --admin-email=demo@admin.com --admin-user=admin --admin-password=Admin@123 --elasticsearch-host=opensearch --elasticsearch-port=9200   
chown -R app:app /var/www/html
exec "$@"