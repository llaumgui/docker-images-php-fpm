# My php-fpm image, based on alpine Linux, configured and forked from the
# official PHP docker repository.
# @see: https://store.docker.com/images/php
FROM php:7.1-fpm-alpine
MAINTAINER Guillaume Kulakowski <guillaume@kulakowski.fr>

LABEL Description="Fork of php-fpm:7.1"
LABEL Vendor="Guillaume Kulakowski"
LABEL License="MIT"
LABEL Version=7.1-fpm


# ---------------------------------------------------------- Setup build options
ARG DOCKER_PHP_ENABLE_APCU
ARG DOCKER_PHP_ENABLE_COMPOSER
ARG DOCKER_PHP_ENABLE_LDAP
ARG DOCKER_PHP_ENABLE_MEMCACHED
ARG DOCKER_PHP_ENABLE_MONGODB
ARG DOCKER_PHP_ENABLE_MYSQL
ARG DOCKER_PHP_ENABLE_POSTGRESQL
ARG DOCKER_PHP_ENABLE_REDIS
ARG DOCKER_PHP_ENABLE_SYMFONY
ARG DOCKER_PHP_ENABLE_XDEBUG

RUN	echo -n "With apcu support:          " ; if [[ "${DOCKER_PHP_ENABLE_APCU}" = "on" ]] ; 	     then echo "Yes"; else echo "No" ; fi && \
	echo -n "With composer support:      " ; if [[ "${DOCKER_PHP_ENABLE_COMPOSER}" = "on" ]] ; 	 then echo "Yes"; else echo "No" ; fi && \
	echo -n "With ldap support:          " ; if [[ "${DOCKER_PHP_ENABLE_LDAP}" = "on" ]] ; 		 then echo "Yes"; else echo "No" ; fi && \
	echo -n "With memcached support:     " ; if [[ "${DOCKER_PHP_ENABLE_MEMCACHED}" = "on" ]] ;  then echo "Yes"; else echo "No" ; fi && \
	echo -n "With mongodb support:       " ; if [[ "${DOCKER_PHP_ENABLE_MONGODB}" = "on" ]] ; 	 then echo "Yes"; else echo "No" ; fi && \
	echo -n "With mysql support:         " ; if [[ "${DOCKER_PHP_ENABLE_MYSQL}" = "on" ]] ; 	 then echo "Yes"; else echo "No" ; fi && \
	echo -n "With postgresql support:    " ; if [[ "${DOCKER_PHP_ENABLE_POSTGRESQL}" = "on" ]] ; then echo "Yes"; else echo "No" ; fi && \
	echo -n "With redis support:         " ; if [[ "${DOCKER_PHP_ENABLE_REDIS}" = "on" ]] ; 	 then echo "Yes"; else echo "No" ; fi && \
	echo -n "With symfony support:       " ; if [[ "${DOCKER_PHP_ENABLE_SYMFONY}" = "on" ]] ; 	 then echo "Yes"; else echo "No" ; fi && \
	echo -n "With xdebug support:        " ; if [[ "${DOCKER_PHP_ENABLE_XDEBUG}" = "on" ]] ; 	 then echo "Yes"; else echo "No" ; fi


# --------------------------------------------------------- Install dependancies
RUN	apk add --update --no-cache \
		# Dependancy for intl
        icu-libs \
        # Misc tools
        git \
        imagemagick


# --------------------------------------------------- Install build dependancies
RUN apk add --update --no-cache --virtual .docker-php-global-dependancies \
		# Build dependencies for gd
		freetype-dev \
		libjpeg-turbo-dev \
		libpng-dev \
		# Build dependency for intl
		icu-dev \
		# Build dependencies for XML part
		libxml2-dev \ 
		ldb-dev \
		# Build dependancies for Pecl
		autoconf \
		g++ \
		make \
		# Build dependancy for APCu 
		pcre-dev \
		# Misc build dependancy
		wget


# ------------------------------------------------------- Install php extensions
RUN php -m && \
    NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) && \
	docker-php-ext-install bcmath && \
    docker-php-ext-configure gd \
		--with-freetype-dir=/usr/include/ \
		--with-jpeg-dir=/usr/include/ \
		--with-png-dir=/usr/include/ && \
    docker-php-ext-install -j${NPROC} gd && \
    docker-php-ext-install -j${NPROC} intl && \
    docker-php-ext-install mbstring && \
    docker-php-ext-install opcache && \
    docker-php-ext-install xmlrpc && \
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

# Enable LDAP
RUN if [ "${DOCKER_PHP_ENABLE_LDAP}" != "off" ]; then \
 	    # Dependancy for ldap
        apk add --update --no-cache \
            libldap && \
        # Build dependancy for ldap
		apk add --update --no-cache --virtual .docker-php-ldap-dependancies \
			openldap-dev && \
		docker-php-ext-install ldap && \
		apk del .docker-php-ldap-dependancies && \
		php -m; \
	else \
		echo "Skip ldap support"; \
    fi

# Enable Memcached
RUN if [ "${DOCKER_PHP_ENABLE_MEMCACHED}" != "off" ]; then \
 	    # Dependancy for ldap
        apk add --update --no-cache \
            libmemcached-libs && \
        # Build dependancies for memcached
		apk add --update --no-cache --virtual .docker-php-memcached-dependancies \
			cyrus-sasl-dev \
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
			# Dependancies for MongoDB
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
			# Dependancy for mysql
			mysql-client && \
		# MySQLnd is already compiled.
		# See: https://github.com/docker-library/php/issues/167
#        docker-php-ext-install mysqlnd && \
        docker-php-ext-install mysqli && \
        docker-php-ext-install pdo_mysql && \
		apk del .docker-php-mysql-dependancies && \
		php -m; \
	else \
		echo "Skip mysql support"; \
    fi

# Enable PostgreSQL
RUN if [ "${DOCKER_PHP_ENABLE_POSTGRESQL}" != "off" ]; then \
 	    # Dependancy for PostgreSQL
        apk add --update --no-cache \
            libpq && \
        # Build dependancies for PostgreSQL
        apk add --update --no-cache --virtual .docker-php-postgresql-dependancies \
			postgresql-client \
			postgresql-dev && \
        docker-php-ext-install pdo_pgsql && \
        docker-php-ext-install pgsql && \
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
 	    # Dependancy for PostgreSQL
        apk add --update --no-cache \
            yaml && \
		# Build dependancy for YAML
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
        yes | pecl install xdebug && \
        echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini && \
        echo "xdebug.remote_enable=on" >> /usr/local/etc/php/conf.d/xdebug.ini && \
        echo "xdebug.remote_autostart=off" >> /usr/local/etc/php/conf.d/xdebug.ini && \
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


# ---------------------------------------------------------Install some binaries
# Install php-fpm-cli from https://gist.github.com/muhqu/91497df3a110f594b992.
ADD https://gist.githubusercontent.com/muhqu/91497df3a110f594b992/raw/58bf4ee037b637c24dea2f80a8c6735d5229f4d6/php-fpm-cli /usr/bin/php-fpm-cli
ADD bin/apcu_clear_cache.sh /usr/bin/apcu_clear_cache
RUN chmod +x /usr/bin/php-fpm-cli \
             /usr/bin/apcu_clear_cache

# ---------------------------------------------------------------- Configuration
# My configuration.
RUN sed -i "/^;security.limit_extensions =.*/asecurity.limit_extensions = .php .php7 .php71" /usr/local/etc/php-fpm.d/www.conf
COPY php.d /usr/local/etc/php/conf.d
COPY etc /usr/local/etc/php

# Big clean
RUN apk del .docker-php-global-dependancies && \
	rm -rf /var/cache/apk/* && \
	docker-php-source delete

EXPOSE 9000
WORKDIR /var/www