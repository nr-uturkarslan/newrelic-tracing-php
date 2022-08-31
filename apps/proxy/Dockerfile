FROM php:8.1-apache

RUN apt-get update
RUN echo Y | apt-get upgrade
RUN echo Y | apt-get install zip

RUN a2enmod rewrite

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"

RUN php composer-setup.php --install-dir=/usr/local/bin --filename=composer
RUN rm composer-setup.php

RUN /usr/local/bin/composer self-update
RUN /usr/local/bin/composer require monolog/monolog --quiet

COPY . .
