# PHP-FPM.
FROM centos:7
MAINTAINER Guillaume Kulakowski <guillaume@kulakowski.fr>

LABEL Description="CentOS PHP-FPM 5.6 from SCL"
LABEL Vendor="Guillaume Kulakowski"
LABEL License=MIT
LABEL Version=5.6-1.2

# Install RH-PHP56 and more-php56 (by Remi) collections from SCL.
RUN yum update -y && \
    yum install centos-release-scl -y && \
    yum localinstall -y https://www.softwarecollections.org/en/scls/remi/php56more/epel-7-x86_64/download/remi-php56more-epel-7-x86_64.noarch.rpm \
                        https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && \
    yum install -y rh-php56-php-bcmath \
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
                   more-php56-php-pecl-imagick \
                   more-php56-php-mcrypt \
                   more-php56-php-pecl-memcached \
                   more-php56-php-pecl-redis \
                   more-php56-php-pecl-solr2 \
                   more-php56-php-twig \
                   more-php56-php-pecl-varnish \
                   more-php56-php-pecl-yaml \
                   ImageMagick \
                   fcgi \
                   git \
                   wget && \
    yum clean all

# Add symlink for configuration.
RUN ln -s /etc/opt/rh/rh-php56/php.d/ /etc && \
    ln -s /etc/opt/rh/rh-php56/php-fpm.d/ /etc && \
    ln -s /var/opt/rh/rh-php56/log/php-fpm/ /var/log && \
    mkdir -p /var/www

# Install /usr/bin/php.
COPY bin /usr/bin
RUN chmod +x /usr/bin/*

# Install composer.
RUN mkdir -p /opt/org/composer
ADD https://getcomposer.org/composer.phar /opt/org/composer/composer.phar
RUN chmod 755 /opt/org/composer/composer.phar

# Install Drush from git.
RUN git clone https://github.com/drush-ops/drush.git /opt/drush && \
    cd /opt/drush && git checkout 7.0.0 && composer install && \
    ln -s /opt/drush/drush /usr/bin/drush

# Install php-fpm-cli from https://gist.github.com/muhqu/91497df3a110f594b992.
ADD https://gist.githubusercontent.com/muhqu/91497df3a110f594b992/raw/58bf4ee037b637c24dea2f80a8c6735d5229f4d6/php-fpm-cli /usr/bin/php-fpm-cli
RUN chmod +x /usr/bin/php-fpm-cli

# My configuration.
RUN sed -i "s/listen = 127.0.0.1:9000/listen = [::]:9000/g" /etc/php-fpm.d/www.conf && \
    sed -i "s/listen.allowed_clients = /;listen.allowed_clients = /g" /etc/php-fpm.d/www.conf && \
    sed -i "/^;security.limit_extensions =.*/asecurity.limit_extensions = .php .php5 .php56" /etc/php-fpm.d/www.conf
COPY php.d /etc/php.d/
COPY etc /etc/opt/rh/rh-php56

EXPOSE 9000
WORKDIR /var/www

CMD ["scl", "enable", "rh-php56", "php-fpm -F"]