FROM php:8.1-apache

### General ###
RUN apt-get update
RUN echo Y | apt-get upgrade
RUN echo Y | apt-get install zip

RUN a2enmod rewrite
######

### Composer ###
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"

RUN php composer-setup.php --install-dir=/usr/local/bin --filename=composer
RUN rm composer-setup.php

RUN /usr/local/bin/composer self-update
RUN /usr/local/bin/composer require monolog/monolog --quiet
######

### New Relic ###
ARG newRelicAppName
ARG newRelicLicenseKey

RUN \
  curl -L "https://download.newrelic.com/php_agent/release/newrelic-php5-10.0.0.312-linux.tar.gz" | tar -C /tmp -zx && \
  export NR_INSTALL_USE_CP_NOT_LN=1 && \
  export NR_INSTALL_SILENT=1 && \
  /tmp/newrelic-php5-*/newrelic-install install && \
  rm -rf /tmp/newrelic-php5-* /tmp/nrinstall*

RUN sed -i \
    -e s/"REPLACE_WITH_REAL_KEY"/$newRelicLicenseKey/ \
    -e s/newrelic.appname = "PHP Application"/newrelic.appname = $newRelicAppName/ \
    -e 's/;newrelic.daemon.app_connect_timeout =.*/newrelic.daemon.app_connect_timeout=15s/' \
    -e 's/;newrelic.daemon.start_timeout =.*/newrelic.daemon.start_timeout=5s/' \
    /usr/local/etc/php/conf.d/newrelic.ini
######

COPY . .
