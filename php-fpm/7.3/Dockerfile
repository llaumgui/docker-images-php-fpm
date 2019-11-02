# My php-fpm image, based on alpine Linux, configured and forked from the
# official PHP docker repository.
# @see: https://store.docker.com/images/php
FROM php:7.3-fpm-alpine
MAINTAINER Guillaume Kulakowski <guillaume@kulakowski.fr>

LABEL Description="Fork of php-fpm:7.3"
LABEL Vendor="Guillaume Kulakowski"
LABEL License="MIT"
LABEL Version=7.3-fpm


# ---------------------------------------------------------- Setup build options
ARG DOCKER_PHP_ENABLE_APCU
ARG DOCKER_PHP_ENABLE_COMPOSER
ARG DOCKER_PHP_ENABLE_EXIF
ARG DOCKER_PHP_ENABLE_IMAGICK
ARG DOCKER_PHP_ENABLE_LDAP
ARG DOCKER_PHP_ENABLE_MEMCACHED
ARG DOCKER_PHP_ENABLE_MONGODB
ARG DOCKER_PHP_ENABLE_MYSQL
ARG DOCKER_PHP_ENABLE_POSTGRESQL
ARG DOCKER_PHP_ENABLE_REDIS
ARG DOCKER_PHP_ENABLE_SYMFONY
ARG DOCKER_PHP_ENABLE_XDEBUG
ARG DOCKER_USER_UID=false
ARG DOCKER_USER_GID=false

RUN echo -n "With apcu support:          " ; if [[ "${DOCKER_PHP_ENABLE_APCU}" = "on" ]] ;        then echo "Yes"; else echo "No" ; fi && \
    echo -n "With composer support:      " ; if [[ "${DOCKER_PHP_ENABLE_COMPOSER}" = "on" ]] ;    then echo "Yes"; else echo "No" ; fi && \
    echo -n "With exif support:          " ; if [[ "${DOCKER_PHP_ENABLE_EXIF}" = "on" ]] ;      then echo "Yes"; else echo "No" ; fi && \
    echo -n "With imagick support:       " ; if [[ "${DOCKER_PHP_ENABLE_IMAGICK}" = "on" ]] ;      then echo "Yes"; else echo "No" ; fi && \
    echo -n "With ldap support:          " ; if [[ "${DOCKER_PHP_ENABLE_LDAP}" = "on" ]] ;      then echo "Yes"; else echo "No" ; fi && \
    echo -n "With memcached support:     " ; if [[ "${DOCKER_PHP_ENABLE_MEMCACHED}" = "on" ]] ;  then echo "Yes"; else echo "No" ; fi && \
    echo -n "With mongodb support:       " ; if [[ "${DOCKER_PHP_ENABLE_MONGODB}" = "on" ]] ;    then echo "Yes"; else echo "No" ; fi && \
    echo -n "With mysql support:         " ; if [[ "${DOCKER_PHP_ENABLE_MYSQL}" = "on" ]] ;    then echo "Yes"; else echo "No" ; fi && \
    echo -n "With postgresql support:    " ; if [[ "${DOCKER_PHP_ENABLE_POSTGRESQL}" = "on" ]] ; then echo "Yes"; else echo "No" ; fi && \
    echo -n "With redis support:         " ; if [[ "${DOCKER_PHP_ENABLE_REDIS}" = "on" ]] ;    then echo "Yes"; else echo "No" ; fi && \
    echo -n "With symfony support:       " ; if [[ "${DOCKER_PHP_ENABLE_SYMFONY}" = "on" ]] ;    then echo "Yes"; else echo "No" ; fi && \
    echo -n "With xdebug support:        " ; if [[ "${DOCKER_PHP_ENABLE_XDEBUG}" = "on" ]] ;      then echo "Yes"; else echo "No" ; fi && \
    if [ -z ${DOCKER_USER_UID+x} ]; then echo "DOCKER_USER_UID is unset"; DOCKER_USER_UID=1000; else echo "DOCKER_USER_UID is set to '$DOCKER_USER_UID'"; fi && \
    if [ -z ${DOCKER_USER_GID+x} ]; then echo "DOCKER_USER_GID is unset"; DOCKER_USER_GID=1000; else echo "DOCKER_USER_GID is set to '$DOCKER_USER_GID'"; fi


# --------------------------------------------------------- Install dependancies
RUN apk add --update --no-cache \
        # Dependancy for intl \
        icu-libs \
        libintl \
        # Dependancy for zip \
        libzip \
        # Misc tools \
        git \
        patch


# --------------------------------------------------- Install build dependancies
RUN apk add --update --no-cache --virtual .docker-php-global-dependancies \
        # Build dependencies for gd \
        freetype-dev \
        libjpeg-turbo-dev \
        libpng-dev \
        # Build dependency for gettext \
        gettext-dev \
        # Build dependency for intl \
        icu-dev \
        # Build dependencies for XML part \
        libxml2-dev \
        ldb-dev \
        # Build dependencies for Zip \
        libzip-dev \
        # Build dependancies for Pecl \
        autoconf \
        g++ \
        make \
        # Build dependancy for APCu \
        pcre-dev \
        # Misc build dependancy \
        wget


# ------------------------------------------------------- Install php extensions
RUN php -m && \
    docker-php-ext-configure bcmath --enable-bcmath && \
    docker-php-ext-configure gd \
      --with-freetype-dir=/usr/include/ \
      --with-jpeg-dir=/usr/include/ \
      --with-png-dir=/usr/include/ && \
    docker-php-ext-configure gettext && \
    docker-php-ext-configure intl --enable-intl && \
    docker-php-ext-configure mbstring --enable-mbstring && \
    docker-php-ext-configure opcache --enable-opcache && \
    docker-php-ext-configure pcntl --enable-pcntl && \
    docker-php-ext-configure soap && \
    docker-php-ext-configure zip --enable-zip --with-libzip && \
    docker-php-ext-install bcmath \
        gd \
        gettext \
        intl \
        mbstring \
        opcache \
        pcntl \
        soap \
        zip && \
    php -m


# --------------------------------------------------- Conditionnal installations
# Enable APCu
RUN if [ "${DOCKER_PHP_ENABLE_APCU}" != "off" ]; then \
      pecl install apcu && \
      docker-php-ext-enable apcu && \
      php -m; \
    else \
      echo "Skip apcu support"; \
    fi

# Enable EXIF
RUN if [ "${DOCKER_PHP_ENABLE_EXIF}" != "off" ]; then \
      docker-php-ext-install exif && \
      docker-php-ext-enable exif && \
      php -m; \
    else \
      echo "Skip apcu support"; \
    fi

    
# Enable imagick
RUN if [ "${DOCKER_PHP_ENABLE_IMAGICK}" != "off" ]; then \
      # Dependancy for imagick \
      apk add --update --no-cache \
          imagemagick \
          imagemagick-libs && \

      # Build dependancy for imagick \
      apk add --update --no-cache --virtual .docker-php-imagick-dependancies \
          imagemagick-dev && \
      pecl install imagick && \
      docker-php-ext-enable imagick && \
      apk del .docker-php-imagick-dependancies && \
      php -m; \
    else \
      echo "Skip apcu support"; \
    fi

# Enable LDAP
RUN if [ "${DOCKER_PHP_ENABLE_LDAP}" != "off" ]; then \
      # Dependancy for ldap \
      apk add --update --no-cache \
          libldap && \
      # Build dependancy for ldap \
      apk add --update --no-cache --virtual .docker-php-ldap-dependancies \
          openldap-dev && \
      docker-php-ext-configure ldap && \
      docker-php-ext-install ldap && \
      apk del .docker-php-ldap-dependancies && \
      php -m; \
    else \
      echo "Skip ldap support"; \
    fi

# Enable Memcached
RUN if [ "${DOCKER_PHP_ENABLE_MEMCACHED}" != "off" ]; then \
      # Dependancy for ldap \
      apk add --update --no-cache \
          libevent \
          libmemcached-libs && \
      # Build dependancies for memcached \
      apk add --update --no-cache --virtual .docker-php-memcached-dependancies \
          cyrus-sasl-dev \
          libevent-dev \
          libmemcached-dev && \
      pecl install memcached && \
      docker-php-ext-enable memcached && \
      apk del .docker-php-memcached-dependancies && \
      php -m; \
    else \
      echo "Skip memcached support"; \
    fi

# Enable MongoDB
RUN if [ "${DOCKER_PHP_ENABLE_MONGODB}" != "off" ]; then \
      apk add --update --no-cache --virtual .docker-php-mongodb-dependancies \
          # Dependancies for MongoDB \
          heimdal-dev && \
      pecl install mongodb && \
      docker-php-ext-enable mongodb && \
      apk del .docker-php-mongodb-dependancies && \
      php -m; \
    else \
      echo "Skip mongodb support"; \
    fi

# Enable MySQL
RUN if [ "${DOCKER_PHP_ENABLE_MYSQL}" != "off" ]; then \
      apk add --update --no-cache --virtual .docker-php-mysql-dependancies \
          # Dependancy for mysql \
          mysql-client && \
      # MySQLnd is already compiled. \
      # See: https://github.com/docker-library/php/issues/167 \
      docker-php-ext-configure mysqli && \
      docker-php-ext-configure pdo_mysql && \
      docker-php-ext-install mysqli \
          pdo_mysql && \
      apk del .docker-php-mysql-dependancies && \
      php -m; \
    else \
      echo "Skip mysql support"; \
    fi

# Enable PostgreSQL
RUN if [ "${DOCKER_PHP_ENABLE_POSTGRESQL}" != "off" ]; then \
      # Dependancy for PostgreSQL \
      apk add --update --no-cache \
          libpq && \
      # Build dependancies for PostgreSQL \
      apk add --update --no-cache --virtual .docker-php-postgresql-dependancies \
          postgresql-client \
          postgresql-dev && \
      docker-php-ext-configure pdo_pgsql && \
      docker-php-ext-configure pgsql && \
      docker-php-ext-install pdo_pgsql \
          pgsql && \
      apk del .docker-php-postgresql-dependancies && \
      php -m; \
    else \
      echo "Skip postgresql support"; \
    fi

# Enable Redis
RUN if [ "${DOCKER_PHP_ENABLE_REDIS}" != "off" ]; then \
      pecl install redis && \
      docker-php-ext-enable redis && \
      php -m; \
    else \
      echo "Skip redis support"; \
    fi

# Enable Symfony extensions
RUN if [ "${DOCKER_PHP_ENABLE_SYMFONY}" != "off" ]; then \
      # Dependancy for PostgreSQL \
      apk add --update --no-cache \
          yaml && \
      # Build dependancy for YAML \
      apk add --update --no-cache --virtual .docker-php-symfony-dependancies \
          yaml-dev && \
      pecl install yaml && \
      docker-php-ext-enable yaml; \
      apk del .docker-php-symfony-dependancies && \
      php -m; \
    else \
      echo "Skip symfony support"; \
    fi

# Enable Xdebug
RUN if [ "${DOCKER_PHP_ENABLE_XDEBUG}" != "off" ]; then \
      # Build dependancy for XDebug \
      apk add --update --no-cache --virtual .docker-php-xdebug-dependancies \
          bash \
          git && \
      git clone https://github.com/xdebug/xdebug.git && \
      cd xdebug && \
      ./rebuild.sh && \
      docker-php-ext-enable xdebug && \
      echo "xdebug.remote_enable=on" >> /usr/local/etc/php/conf.d/xdebug.ini && \
      echo "xdebug.remote_autostart=off" >> /usr/local/etc/php/conf.d/xdebug.ini && \
      rm -rf xdebug && \
      apk del .docker-php-xdebug-dependancies && \
      php -m; \
    else \
      echo "Skip xdebug support"; \
    fi


# --------------------------------------------- Conditionnal tools installations
# Install composer.
RUN if [ "${DOCKER_PHP_ENABLE_COMPOSER}" != "off" ]; then \
      EXPECTED_SIGNATURE=$(wget -q -O - https://composer.github.io/installer.sig) && \
      php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
      ACTUAL_SIGNATURE=$(php -r "echo hash_file('SHA384', 'composer-setup.php');") && \
      if [ "$EXPECTED_SIGNATURE" != "$ACTUAL_SIGNATURE" ]; then \
        >&2 echo 'ERROR: Invalid installer signature' && \
        rm composer-setup.php && \
        exit 1; \
      else \
        php composer-setup.php --install-dir=/usr/bin --filename=composer && \
        RESULT=$? && \
        rm composer-setup.php && \
        exit $RESULT && \
        composer -V; \
      fi; \
    else \
      echo "Skip composer support"; \
    fi


# ---------------------------------------------------------------- Configuration
# My configuration.
RUN sed -i "/^;security.limit_extensions =.*/asecurity.limit_extensions = .php .php7 .php73" /usr/local/etc/php-fpm.d/www.conf
COPY php.d /usr/local/etc/php/conf.d
COPY etc /usr/local/etc/php

# Big clean
RUN apk del .docker-php-global-dependancies && \
    rm -rf /var/cache/apk/* && \
    docker-php-source delete

# Add user for php-cli
RUN if [ "${DOCKER_USER_GID}" != "false" ] && [ "${DOCKER_USER_UID}" != "false" ]; then \
      addgroup -g ${DOCKER_USER_GID} php-cli && \
      adduser -D -u ${DOCKER_USER_UID} -G php-cli php-cli; \
    else \
      echo "No user for php-cli"; \
    fi

EXPOSE 9000
WORKDIR /var/www
