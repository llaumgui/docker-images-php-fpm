# My php-fpm image, based on debian Linux, configured and forked from the
# official Nextcloud docker repository.
# @see: https://github.com/nextcloud/docker/blob/09fecda4067434c11f955cdd3000ed950fe48d04/27/fpm/Dockerfile
FROM php:8.4-fpm


# -------------------------------------------- Set environment and ARG variables
ENV \
    # Need by pageres
    PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    CHROMIUM_PATH=/usr/bin/chromium \
    # Set default PUID / PGUID \
    PUID=82 \
    PGID=82 \
    # Setup s6 overlay
    S6_CMD_WAIT_FOR_SERVICES_MAXTIME=0 \
    S6_VERBOSITY=2
ARG \
    # Set version for s6 overlay \
    ARG S6_OVERLAY_VERSION="3.2.0.2" \
    ARG S6_OVERLAY_ARCH="x86_64"


# ------------------------------------------------------------------- s6 overlay
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-${S6_OVERLAY_ARCH}.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-${S6_OVERLAY_ARCH}.tar.xz
# Optional symlinks
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-${S6_OVERLAY_ARCH}.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-${S6_OVERLAY_ARCH}.tar.xz


# ----------------------------------------------------------------- Install cron
RUN set -eux; \
    apt-get update; \
    apt-get install --no-install-recommends -y \
        busybox-static; \
    rm -rf /var/lib/apt/lists/*;


# --------------------------------------------- Install Search and LLM utilities
RUN set -eux; \
    apt-get update; \
    apt-get install --no-install-recommends -y \
        # Install tesseract and ocrmypdf for OCR \
        tesseract-ocr \
        tesseract-ocr-eng \
        ocrmypdf \
        # Install Python for Local Large language model \
        python-is-python3 \
        python3-venv; \
    rm -rf /var/lib/apt/lists/*


# ------------------------------------------------------- Install misc utilities
RUN set -eux; \
    apt-get update; \
    apt-get install --no-install-recommends -y \
        bzip2 \
        curl \
        chromium \
        ffmpeg \
        git \
        gnupg \
        imagemagick \
        libfcgi-bin \
        libldap-common \
        libmagickwand-6.q16-6 \
        libmagickcore-6.q16-6-extra \
        libpng16-16 \
        libpq5 \
        libzip4 \
        nodejs \
        npm \
        openssl \
        procps \
        rsync \
        unzip \
        wget; \
    rm -rf /var/lib/apt/lists/*


# --------------------------------------------------------- Install dependancies
RUN set -eux; \
    fetchDeps=" \
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
        # Build dependancies for PostgreSQL \
        libpq-dev  \
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
    rm -rf /var/lib/apt/lists/*

# ------------------------------------------------------- Install php extensions \
RUN php -m; \
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
        pdo_pgsql \
        pgsql \
        shmop \
        soap \
        sysvsem \
        zip;


# ------------------------------------------------------ Install pecl extensions
RUN php -m; \
    pecl install apcu; \
    pecl install igbinary; \
    #pecl install imagick; \
    # Tempory workaround - BEGIN \
    git clone https://github.com/Imagick/imagick.git --depth 1 /tmp/imagick; \
    cd /tmp/imagick || exit; \
    git fetch origin master; \
    git switch master; \
    cd /tmp/imagick || exit; \
    sed -i 's/php_strtolower/zend_str_tolower/g' imagick.c; \
    phpize; \
    ./configure; \
    make; \
    make install; \
    # Tempory workaround - END \
    pecl install redis \
        --configureoptions 'enable-redis-igbinary="yes" enable-redis-zstd="yes" enable-redis-lz4="yes"'; \
    docker-php-ext-enable \
        igbinary \
        apcu \
        imagick \
        redis; \
    rm -r /tmp/pear; \
    php -m ;


# -------------------------------------------------------------- Install pageres
RUN npm install -g pageres-cli;


# ------------------------------------------------------------------ Big cleanup
RUN apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false ${fetchDeps}; \
    rm -rf /var/lib/apt/lists/* \
           /tmp/* \
           /var/tmp/* \
           /usr/share/doc/*


# -------------------------------------- Install php-fpm-healthcheck & cachetool
RUN sed -i 's#^;pm.status_path = .*#pm.status_path = /status#g' /usr/local/etc/php-fpm.d/www.conf; \
    wget  --progress=dot:giga -O /usr/local/bin/php-fpm-healthcheck https://raw.githubusercontent.com/renatomefi/php-fpm-healthcheck/master/php-fpm-healthcheck; \
    chmod +x /usr/local/bin/php-fpm-healthcheck; \
    wget  --progress=dot:giga -O /usr/local/bin/cachetool https://github.com/gordalina/cachetool/releases/latest/download/cachetool.phar; \
    chmod +x /usr/local/bin/cachetool


# ---------------------------------------------------------------- Configuration
# Healthcheck
HEALTHCHECK --interval=1m --timeout=10s --start-period=1m --retries=3 CMD FCGI_CONNECT=localhost:9000 php-fpm-healthcheck

# Patch pageres
COPY patch /tmp
RUN cd /usr/local/lib/node_modules/pageres-cli && patch -p0 < /tmp/pageres.patch && rm -f /tmp/pageres.patch

# Remove access log
RUN sed -i 's#^access.log = /proc/self/fd/2#access.log = /dev/null#g' /usr/local/etc/php-fpm.d/docker.conf

# Copy all rootfs files with configuration and others scripts
COPY rootfs/ /
RUN chmod 755 /etc/s6-overlay/s6-rc.d/*/run && \
chmod 755 /etc/s6-overlay/s6-rc.d/*/up && \
    chmod 755 /usr/local/bin/nc_*.sh

EXPOSE 9000
WORKDIR /var/www

ENTRYPOINT ["/init"]
