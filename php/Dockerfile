FROM php:7-apache 

LABEL maintainer="Aislan Max <marfebr@gmail.com>"

RUN apt-get update && apt-get install -y bash git \
    libmcrypt-dev default-libmysqlclient-dev postgresql-server-dev-11 && \
    docker-php-ext-configure mysqli && \
    docker-php-ext-install mysqli && \
    docker-php-ext-configure pdo && \
    docker-php-ext-install pdo && \
    docker-php-ext-configure pdo_mysql && \
    docker-php-ext-install pdo_mysql && \
    docker-php-ext-configure pdo_pgsql && \
    docker-php-ext-install pdo_pgsql && \
    apt-get clean && rm -rf /var/cache/apt/*

RUN curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer



