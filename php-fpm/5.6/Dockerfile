# PHP-FPM.
FROM centos:7
MAINTAINER Guillaume Kulakowski <guillaume@kulakowski.fr>

LABEL Description="CentOS PHP-FPM 5.6 from SCL"
LABEL Vendor="Guillaume Kulakowski"
LABEL License=MIT
LABEL Version=5.6-1.0

EXPOSE 9000

# Install RH-PHP56 collection from SCL.
RUN yum localinstall -y https://www.softwarecollections.org/en/scls/rhscl/rh-php56/epel-7-x86_64/download/rhscl-rh-php56-epel-7-x86_64.noarch.rpm \
  https://www.softwarecollections.org/en/scls/remi/php56more/epel-7-x86_64/download/remi-php56more-epel-7-x86_64.noarch.rpm \
  https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

# Install PHP 5.6 from SCL.
RUN yum update -y && yum install -y rh-php56-php-bcmath \
    rh-php56-php-cli \
    rh-php56-php-common \
    rh-php56-php-dbg \
    rh-php56-php-fpm \
    rh-php56-php-gd \
    rh-php56-php-intl \
    rh-php56-php-ldap \
    rh-php56-php-mbstring \
    rh-php56-php-mysqlnd \
    rh-php56-php-opcache \
    rh-php56-php-pdo \
    rh-php56-php-pear \
    rh-php56-php-pecl-jsonc \
    rh-php56-php-pecl-memcache \
    rh-php56-php-pecl-mongo \
    rh-php56-php-pecl-xdebug \
    rh-php56-php-pgsql \
    rh-php56-php-process \
    rh-php56-php-pspell \
    rh-php56-php-recode \
    rh-php56-php-soap \
    rh-php56-php-xml \
    rh-php56-php-xmlrpc \
    more-php56-php-pecl-apcu \
    more-php56-php-pecl-memcached \
    more-php56-php-pecl-redis \
    more-php56-php-pecl-solr2 \
    more-php56-php-pecl-sphinx \
    more-php56-php-twig \
    more-php56-php-pecl-varnish \
    more-php56-php-pecl-yaml \
    git
RUN yum clean all

# Install /usr/bin/php
COPY bin/php /usr/bin/php
RUN chmod +x /usr/bin/php

# Install composer
RUN mkdir -p /opt/org/composer
ADD https://getcomposer.org/composer.phar /opt/org/composer/composer.phar
COPY bin/composer /usr/bin/composer
RUN chmod +x /usr/bin/composer

# Install Drush
RUN git clone https://github.com/drush-ops/drush.git /opt/drush
RUN cd /opt/drush && git checkout 7.0.0 && composer install
RUN ln -s /opt/drush/drush /usr/bin/drush 

# Symlink.
RUN ln -s /etc/opt/rh/rh-php56/php.d/ /etc
RUN ln -s /etc/opt/rh/rh-php56/php-fpm.d/ /etc
RUN ln -s /var/opt/rh/rh-php56/log/php-fpm/ /var/log
RUN mkdir -p /var/www

# My configuration.
RUN sed -i "s/listen = 127.0.0.1:9000/listen = [::]:9000/g" /etc/php-fpm.d/www.conf
RUN sed -i "s/listen.allowed_clients = /;listen.allowed_clients = /g" /etc/php-fpm.d/www.conf
RUN sed -i "/^;security.limit_extensions =.*/asecurity.limit_extensions = .php .php5 .php56" /etc/php-fpm.d/www.conf

WORKDIR /var/www

CMD ["scl", "enable", "rh-php56", "php-fpm -F"]