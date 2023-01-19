FROM php:8.1-fpm
LABEL maintainer="Ahmed Allam <tiefanovic.business@gmail.com>"

ENV MAGENTO_VERSION 2.4.4
ENV INSTALL_DIR /var/www/html
ENV COMPOSER_HOME /var/www/.composer/
ENV PHP_EXTENSIONS bcmath bz2 calendar exif gd gettext intl mysqli opcache pdo_mysql redis soap sockets sodium sysvmsg sysvsem sysvshm xsl zip pcntl

RUN curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer
COPY ./auth.json $COMPOSER_HOME

RUN apt-get update \
  && apt-get upgrade -y \
  && apt-get install -y --no-install-recommends \
  apt-utils \
  sudo \
  iproute2 \
  git \
  gnupg2 \
  ca-certificates \
  lsb-release \
  software-properties-common \
  libbz2-dev \
  libjpeg62-turbo-dev \
  libpng-dev \
  libfreetype6-dev \
  libgmp-dev \
  libgpgme11-dev \
  libicu-dev \
  libldap2-dev \
  libpcre3-dev \
  libpspell-dev \
  libtidy-dev \
  libxslt1-dev \
  libyaml-dev \
  libzip-dev \
  zip \
  && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y \
    cron \
    default-mysql-client \
    git \
    gnupg \
    gzip \
    libbz2-dev \
    libfreetype6-dev \
    libicu-dev \
    libjpeg62-turbo-dev \
    libmagickwand-dev \
    libmcrypt-dev \
    libonig-dev \
    libpng-dev \
    libsodium-dev \
    libssh2-1-dev \
    libwebp-dev \
    libxslt1-dev \
    libzip-dev \
    procps \
    vim \
    zip \
    unzip \
  && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-configure \
  gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/
RUN docker-php-ext-configure \
  opcache --enable-opcache
RUN docker-php-ext-install -j$(nproc) \
  bcmath \
  bz2 \
  calendar \
  exif \
  gd \
  gettext \
  gmp \
  intl \
  mysqli \
  opcache \
  pdo_mysql \
  pspell \
  shmop \
  soap \
  sockets \
  sysvmsg \
  sysvsem \
  sysvshm \
  tidy \
  xsl \
  zip \
  pcntl

RUN pecl install -o -f \
  gnupg \
  mailparse \
  msgpack \
  oauth \
  pcov \
  raphf \
  redis \
  xdebug-3.1.5 \
  xmlrpc-1.0.0RC3 \
  yaml

ARG APP_ID=1000
RUN addgroup --gid "$APP_ID" app \
 && adduser --ingroup app --uid "$APP_ID" --shell /bin/bash --system app
COPY conf/php.ini $PHP_INI_DIR
COPY conf/php-fpm.conf /usr/local/etc/

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN ["chmod", "+x", "/docker-entrypoint.sh"]

RUN chown -R app:app /var/www
RUN su app -c "composer create-project --repository-url=https://repo.magento.com/ magento/project-community-edition $INSTALL_DIR $MAGENTO_VERSION"

RUN cd $INSTALL_DIR  \
    #&& find . -type d -exec chmod 770 {} \; \
    #&& find . -type f -exec chmod 660 {} \; \
    && chmod u+x bin/magento

COPY ./install-script /usr/local/bin/install-script
RUN ["chmod", "+x", "/usr/local/bin/install-script"]

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN echo "* * * * * app /usr/local/bin/php $INSTALL_DIR/bin/magento cron:run | grep -v "Ran jobs by schedule" >> $INSTALL_DIR/var/log/magento.cron.log" >> /etc/cron.d/magento2-cron
RUN chmod 0644 /etc/cron.d/magento2-cron \
    && crontab -u app /etc/cron.d/magento2-cron
ENTRYPOINT ["/docker-entrypoint.sh"]
WORKDIR $INSTALL_DIR
VOLUME $INSTALL_DIR
CMD ["php-fpm", "-R"]