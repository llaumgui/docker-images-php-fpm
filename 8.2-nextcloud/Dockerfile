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
SHELL ["/bin/bash", "-o", "pipefail", "-c"]


# ----------------------------------------------------------------- Install cron
RUN apt-get update && apt-get install --no-install-recommends -y \
        busybox-static && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /var/spool/cron/crontabs
COPY --chmod=755 cron/www-data /var/spool/cron/crontabs/
COPY --chmod=755 cron/*.sh /


# ------------------------------------------------------------------ Supervisord
RUN apt-get update && apt-get install --no-install-recommends -y \
        # Install supervisor to start multiple processes on container startup \
        supervisor&& \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
RUN mkdir "/var/run/supervisor"
RUN rm -rf /etc/supervisor/*
COPY supervisor/*.conf /etc/supervisor
COPY supervisor/*.sh /


# --------------------------------------------- Install Search and LLM utilities
RUN apt-get update && apt-get install --no-install-recommends -y \
        # Install tesseract and ocrmypdf for OCR \
        tesseract-ocr \
        tesseract-ocr-fra \
        tesseract-ocr-eng \
        ocrmypdf \
        # Install Python for Local Large language model \
        python-is-python3 \
        python3-venv && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


# ------------------------------------------------------- Install misc utilities
RUN apt-get update && apt-get install --no-install-recommends -y \
        bzip2 \
        curl \
        ffmpeg \
        libfcgi-bin \
        libldap-common \
        libmagickwand-6.q16-6 \
        libmagickcore-6.q16-6-extra \
        libpng16-16 \
        libzip4 \
        procps \
        unzip \
        wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


# --------------------------------------------------------- Install dependancies
RUN fetchDeps=" \
        # Dependency for bz2 \
        libbz2-dev \
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
        libcurl4-openssl-dev \
        libevent-dev \
        libmcrypt-dev \
        libpq-dev \
        zlib1g-dev" ; \
    apt-get update ; \
    apt-get install --no-install-recommends -y ${fetchDeps}; \
\
\
# ------------------------------------------------------- Install php extensions \
    php -m; \
    debMultiarch="$(dpkg-architecture --query DEB_BUILD_MULTIARCH)"; \
    docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp; \
    docker-php-ext-configure ldap --with-libdir="lib/${debMultiarch}"; \
    docker-php-ext-install -j "$(nproc)" \
        bcmath \
        bz2 \
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
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* \
           /tmp/* \
           /var/tmp/* \
           /usr/share/doc/*


# -------------------------------------------------- Install php-fpm-healthcheck
RUN sed -i 's#^;pm.status_path = .*#pm.status_path = /status#g' /usr/local/etc/php-fpm.d/www.conf && \
    wget  --progress=dot:giga -O /usr/local/bin/php-fpm-healthcheck https://raw.githubusercontent.com/renatomefi/php-fpm-healthcheck/master/php-fpm-healthcheck && \
    chmod +x /usr/local/bin/php-fpm-healthcheck


# ---------------------------------------------------------------- Configuration
# My configuration.
COPY php.d /usr/local/etc/php/conf.d
COPY etc /usr/local/etc/php
# Remove access log
RUN sed -i 's#^access.log = /proc/self/fd/2#access.log = /dev/null#g' /usr/local/etc/php-fpm.d/docker.conf

# Healthcheck
HEALTHCHECK --interval=1m --timeout=10s --start-period=1m --retries=3 CMD FCGI_CONNECT=localhost:9000 php-fpm-healthcheck

EXPOSE 9000
WORKDIR /var/www

ENTRYPOINT []
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
