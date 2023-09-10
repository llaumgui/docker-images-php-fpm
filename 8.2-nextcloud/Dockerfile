# My php-fpm image, based on debian Linux, configured and forked from the
# official Nextcloud docker repository.
# @see: https://github.com/nextcloud/docker/blob/09fecda4067434c11f955cdd3000ed950fe48d04/27/fpm/Dockerfile
FROM php:8.2-fpm

LABEL org.opencontainers.image.title="llaumgui/php-fpm"
LABEL org.opencontainers.image.description="Fork of php-fpm:8.2 based on Nextcloud"
LABEL org.opencontainers.image.vendor="Guillaume Kulakowski"
LABEL org.opencontainers.image.authors="guillaume@kulakowski.fr"
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.version="8.2"

# Fix hadolint #DL4006 (https://github.com/hadolint/hadolint/wiki/DL4006)
SHELL ["/bin/ash", "-eo", "pipefail", "-c"]


# ------------------------------------------------------------ Install utilities
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        # Misc tools \
        bzip2 \
        curl \
        ffmpeg \
        libfcgi-bin \
        libldap-common \
        libmagickwand-6.q16-6 \
        libmagickcore-6.q16-6-extra \
        libpng16-16 \
        libzip4 \
        unzip \
        wget && \
    rm -rf /var/lib/apt/lists/*


# --------------------------------------------------------- Install dependancies
RUN fetchDeps=" \
        # Dependencies for gd \
        libfreetype6-dev  \
        libjpeg-dev\
        libpng-dev \
        libwebp-dev \
        # Build dependency for gmp \
        libgmp-dev \
        # Build dependency for imagick \
        libmagickwand-dev \
        # Build dependency for intl \
        libicu-dev \
        # Build dependency for ldap \
        libldap2-dev \
        # Build dependency for mbstring \
        libonig-dev\
        # Build dependencies for XML part \
        libxml2-dev \
        # Build dependencies for Zip \
        libzip-dev \
        # Misc build dependencies \
        busybox-static \
        libcurl4-openssl-dev \
        libevent-dev \
        libmcrypt-dev \
        libpq-dev \
        zlib1g-dev" ; \
    apt-get update ; \
    apt-get install -y --no-install-recommends ${fetchDeps}; \
\
\
# ------------------------------------------------------- Install php extensions \
    php -m; \
    debMultiarch="$(dpkg-architecture --query DEB_BUILD_MULTIARCH)"; \
    docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp; \
    docker-php-ext-configure ldap --with-libdir="lib/${debMultiarch}"; \
    docker-php-ext-install -j "$(nproc)" \
        bcmath \
        exif \
        gd \
        gettext \
        gmp \
        intl \
        ldap \
        mbstring \
        opcache \
        pcntl \
        pdo_mysql \
        shmop \
        soap \
        sysvsem \
        zip; \
    php -m; \
\
\
# ------------------------------------------------------ Install pecl extensions \
    php -m && \
    pecl install apcu && \
    pecl install imagick && \
    pecl install redis && \
    docker-php-ext-enable \
        apcu \
        imagick \
        redis && \
    rm -r /tmp/pear; \
    php -m ; \
\
\
# ------------------------------------------------------------------ Big cleanup \
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false ${fetchDeps}; \
    rm -rf /var/lib/apt/lists/*


# -------------------------------------------------- Install php-fpm-healthcheck
RUN sed -i 's#^;pm.status_path = .*#pm.status_path = /status#g' /usr/local/etc/php-fpm.d/www.conf && \
    wget  --progress=dot:giga -O /usr/local/bin/php-fpm-healthcheck https://raw.githubusercontent.com/renatomefi/php-fpm-healthcheck/master/php-fpm-healthcheck && \
    chmod +x /usr/local/bin/php-fpm-healthcheck


# ---------------------------------------------------------------- Configuration
# My configuration.
COPY php.d /usr/local/etc/php/conf.d
COPY etc /usr/local/etc/php


# Healthcheck
HEALTHCHECK --interval=1m --timeout=10s --start-period=1m --retries=3 CMD FCGI_CONNECT=localhost:9000 php-fpm-healthcheck

EXPOSE 9000
WORKDIR /var/www
