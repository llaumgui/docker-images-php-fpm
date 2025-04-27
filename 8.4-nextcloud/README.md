# PHP 8.4-nextcloud (PHP-FPM) on Debian (GLibC)

[![Author][ico-bluesky]][link-bluesky]
[![Build Status][ico-ghactions]][link-ghactions]
[![Docker Pulls][ico-docker]][link-docker]
[![Latest Version][ico-version]][link-docker]
[![License][ico-license]](LICENSE)

---
> ⚠ **Warning:** This image is a **PHP-FPM container** and **does not include** Nextcloud or a web server.
>
> - Nextcloud must be mounted separately via a Docker volume to allow web updates.
> - A web server like **[Apache](https://github.com/llaumgui/docker-images-httpd/)** is required to serve Nextcloud.

---

## Table of Contents

- [Features](#features)
- [Customization](#customization)
- [Usage](#usage)
- [Full stack Docker Compose examples](#full-stack-docker-compose-examples)
- [BASH or ZSH alias](#bash-or-zsh-alias)

---

## Features

- **Based on** the official PHP-FPM Debian image (`php:8.4-fpm`). Uses Debian with GLibC for [Recognize](https://github.com/nextcloud/recognize) in *native speed mode*.
- **Inspired by** the [official Nextcloud image](https://github.com/nextcloud/docker/blob/09fecda4067434c11f955cdd3000ed950fe48d04/27/fpm/Dockerfile) (`nextcloud:fpm`) and [LinuxServer.io](https://www.linuxserver.io/).
- **Optimized** for better performance and reliability.

### s6-overlay integration

Use [s6-overlay](https://github.com/just-containers/s6-overlay) for:

- Multi-process container management and customization.
- Allows running custom scripts.
- Override PHP and PHP-FPM configurations easily.
- Supports changing the UID/GID running PHP-FPM.

### Cron Jobs

- Runs the Nextcloud cron job every 5 minutes.
- Runs `preview:pre-generate` cron job every 10 minutes if [Preview Generator](https://github.com/nextcloud/previewgenerator) is present.
- Automatically updates extensions daily if `NC_EXT_UPDATE` is defined.
- Includes [Healthcheck](https://healthchecks.io/).
  - Nextcloud cron job configured via `HEALTHCHECKS_NC_URL`.
  - Preview Generator job configured via `HEALTHCHECKS_PREVIEW_URL`.
  - Automatic daily updates configured via `HEALTHCHECKS_UPDATE_URL`.

### Fulltext Search Support

Includes [Full Text Search](https://apps.nextcloud.com/apps/fulltextsearch) support:

- Installs [Tesseract](https://github.com/tesseract-ocr/tesseract) and [OCRmyPDF](https://ocrmypdf.readthedocs.io/en/latest/) for OCR capabilities.
- Enables `occ fulltextsearch:live` for automatic indexing of new content (only if Full Text Search is present).

### Other Features

- **Additional binaries:**
  - Git.
  - [php-fpm-healthcheck](https://github.com/renatomefi/php-fpm-healthcheck).
  - Python and `python3-venv` (for [LLM](https://apps.nextcloud.com/apps/llm) support).
  - NodeJS for Recognize and [pageres-cli](https://github.com/sindresorhus/pageres-cli).
  - Pageres-cli for website screenshot generation.
- **Recommended configurations included:**
  - APCu, igbinary, OPCache, Postgres support, PHP security hardening.
- **Dedicated `php-cli.ini`** for CLI scripts.

---

## Customization

### Custom UID/GID

You can use PUID / GUID to use a non root user specific instead of the www-data's PID 82. For that, just set environment variables:

```yaml
environment:
  PUID: 'NEXTCLOUD_PUID'
  PGID: 'NEXTCLOUD_PGID'
```

### Custom PHP and PHP-FPM Configuration

You can include your own PHP (`/usr/local/etc/php/conf.d`) and PHP-FPM (`/usr/local/etc/php-fpm.d/`) configuration files:

- For PHP: mount your files to `/custom-php-conf-init.d`
- For PHP-FPM: mount your files to `/custom-php-fpm-conf-init.d`

👉 See the [example](examples/custom-php-fpm-conf-init.d/).

### Custom initialization Scripts

You can execute custom scripts at container initialization, for example, to install additional software or modify configurations. Just put it in `/custom-script-init.d`

👉 See the [example](examples/custom-script-init.d/).

---

## Usage

### Running with Docker CLI

To run the container using the Docker CLI:

```bash
docker run -d \
  -v /docker/volumes/www:/var/www \
  --expose 9000 \
  llaumgui/php:8.4-nextcloud
```

### All environemnts variables

| Variable                   | Description                                       | Default Value |
|----------------------------|---------------------------------------------------|---------------|
| `TZ`                       | Timezone configuration                            |               |
| `HEALTHCHECKS_NC_URL`      | Healthcheck URL for Nextcloud cron job            | `false`       |
| `HEALTHCHECKS_PREVIEW_URL` | Healthcheck URL for Preview Generator job         | `false`       |
| `HEALTHCHECKS_UPDATE_URL`  | Healthcheck URL for automatic updates             | `false`       |
| `NC_EXT_UPDATE`            | Enable automatic extension updates (`true/false`) | `false`       |
| `PUID`                     | User ID for the httpd process (www-data).         | `33`          |
| `PGID`                     | Group ID for the httpd process (www-data).        | `33`          |

---

## Full stack Docker Compose examples

> ⚠ **Warning:** Replace `NEXTCLOUD_DOMAIN`, `HEALTHCHECKS_DOMAIN` and `NEXTCLOUD_PUID` / `NEXTCLOUD_PGID`.

You can use this container in a docker-compose.yml file:

```yaml
# Services definition part
services:

## httpd
  httpd:
    container_name: nextcloud_httpd
    hostname: nextcloud-httpd
    image: ghcr.io/llaumgui/httpd:2.4
    restart: unless-stopped
    environment:
      TZ: 'Europe/Paris'
      PUID: 'NEXTCLOUD_PUID'
      PGID: 'NEXTCLOUD_PGID'
    volumes:
     - /srv/nextcloud/www:/var/www
     - /srv/nextcloud/apache/vhost.d:/usr/local/apache2/conf/vhost.d
    healthcheck:
      test: ["CMD-SHELL", "wget --no-verbose --tries=1 http://localhost:80/status.php -q -O /dev/null || exit 1"]
    depends_on:
      - php
    expose:
     - 80

## PHP
  php:
    container_name: nextcloud_php
    hostname: nextcloud-php
    image: ghcr.io/llaumgui/php:8.4-nextcloud-fpm
    restart: unless-stopped
    environment:
      TZ: 'Europe/Paris'
      PUID: 'NEXTCLOUD_PUID'
      PGID: 'NEXTCLOUD_PGID'
    volumes:
      - type: tmpfs
        target: /tmp:exec
      - /srv/nextcloud/data:/nextcloud/data
      - /srv/nextcloud/logs:/nextcloud/logs
      - /srv/nextcloud/www:/var/www
      - /srv/storage:/srv/storage
    expose:
      - 9000
```

You can also use with [Traefik](https://traefik.io/traefik/), [PostgreSQL](https://www.postgresql.org/), and [Collabora](https://www.collaboraonline.com/fr/):

```yaml
# Services definition part
services:

## httpd
  httpd:
    container_name: nextcloud_httpd
    hostname: nextcloud-httpd
    image: ghcr.io/llaumgui/httpd:2.4
    restart: unless-stopped
    environment:
      TZ: 'Europe/Paris'
      PUID: 'NEXTCLOUD_PUID'
      PGID: 'NEXTCLOUD_PGID'
      HEALTHCHECKS_NC_URL: 'https://HEALTHCHECKS_DOMAIN/ping/xxx'
      HEALTHCHECKS_UPDATE_URL: 'https://HEALTHCHECKS_DOMAIN/ping/xxx'
      HEALTHCHECKS_PREVIEW_URL: 'https://HEALTHCHECKS_DOMAIN/ping/xxx'
      NC_EXT_UPDATE: 'true'
    labels:
      - traefik.enable=true
      - traefik.http.routers.nextcloud.entrypoints=web
      - traefik.http.routers.nextcloud.rule=Host("NEXTCLOUD_DOMAIN")
      - traefik.http.routers.nextcloud.tls.certresolver=letsencrypt
      - traefik.http.routers.nextcloud.middlewares=redirectregex_nextcloud1,redirectregex_nextcloud2
      - traefik.http.middlewares.redirectregex_nextcloud1.redirectregex.permanent=true
      - traefik.http.middlewares.redirectregex_nextcloud1.redirectregex.regex=https?://([^/]*)/.well-known/(card|cal)dav
      - traefik.http.middlewares.redirectregex_nextcloud1.redirectregex.replacement=https://$${1}/remote.php/dav/
      - traefik.http.middlewares.redirectregex_nextcloud2.redirectregex.permanent=true
      - traefik.http.middlewares.redirectregex_nextcloud2.redirectregex.regex=https?://([^/]*)(/.well-known[^#]*)
      - traefik.http.middlewares.redirectregex_nextcloud2.redirectregex.replacement=https://$${1}/index.php$${2}
    volumes:
     - /srv/nextcloud/www:/var/www
     - /srv/nextcloud/apache/vhost.d:/usr/local/apache2/conf/vhost.d
    healthcheck:
      test: ["CMD-SHELL", "wget --no-verbose --tries=1 http://localhost:80/status.php -q -O /dev/null || exit 1"]
    depends_on:
      - php
    expose:
     - 80

## PHP
  php:
    container_name: nextcloud_php
    hostname: nextcloud-php
    image: ghcr.io/llaumgui/php:8.4-nextcloud-fpm
    restart: unless-stopped
    environment:
      TZ: 'Europe/Paris'
      PUID: 'NEXTCLOUD_PUID'
      PGID: 'NEXTCLOUD_PGID'
    volumes:
      - type: tmpfs
        target: /tmp:exec
      - /srv/nextcloud/data:/nextcloud/data
      - /srv/nextcloud/logs:/nextcloud/logs
      - /srv/nextcloud/www:/var/www
      - /srv/storage:/srv/storage
    depends_on:
      - collabora
    expose:
      - 9000

## Postgres
  postgres:
    container_name: storage_postgres
    hostname: storage-postgres
    image: postgres:17
    restart: unless-stopped
    user: NEXTCLOUD_PUID:123
    environment:
      TZ: 'Europe/Paris'
    volumes:
      - /srv/postgresql:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD", "pg_isready", "-U", "miniflux"]
    ports:
     - "127.0.0.1:5432:5432"

## Collabora
  collabora:
    container_name: nextcloud_collabora
    hostname: nextcloud-collabora
    image: collabora/code
    restart: unless-stopped
    environment:
      TZ: 'Europe/Paris'
      dictionaries: 'fr_FR'
      server_name: 'office.NEXTCLOUD_DOMAIN'
      aliasgroup1: 'https://NEXTCLOUD_DOMAIN'
      extra_params: '--o:ssl.enable=false --o:ssl.termination=true --o:net.proto=IPv4'
      username: 'johndo'
      password: 'azerty'
    labels:
      - traefik.enable=true
      - traefik.http.routers.collabora.entrypoints=web
      - traefik.http.routers.collabora.rule=Host("office.NEXTCLOUD_DOMAIN")
      - traefik.http.routers.collabora.tls.certresolver=letsencrypt
      - traefik.http.routers.collabora.service=collabora
      - traefik.http.services.collabora.loadbalancer.server.port=9980
    cap_add:
      - MKNOD
    healthcheck:
      test: ["CMD-SHELL", "curl -s http://localhost:9980 | grep OK || exit 1"]
      interval: 1m
      start_period: 2m
```

---

## BASH or ZSH alias

```bash
alias occ="docker exec -u NEXTCLOUD_PUID -i nextcloud_php php /var/www/occ"
```

[ico-bluesky]: https://img.shields.io/static/v1?label=Author&message=llaumgui&color=208bfe&logo=bluesky&style=flat-square
[link-bluesky]: https://bsky.app/profile/llaumgui.kulakowski.fr
[ico-docker]: https://img.shields.io/docker/pulls/llaumgui/php?color=%2496ed&logo=docker&style=flat-square
[link-docker]: https://hub.docker.com/r/llaumgui/php
[ico-ghactions]: https://img.shields.io/github/actions/workflow/status/llaumgui/docker-images-php-fpm/devops.yml?branch=main&style=flat-square&logo=github&label=CI/CD
[link-ghactions]: https://github.com/llaumgui/docker-images-php-fpm/actions
[ico-version]: https://img.shields.io/docker/v/llaumgui/php?sort=semver&color=%2496ed&logo=docker&style=flat-square
[ico-license]: https://img.shields.io/github/license/llaumgui/docker-images-php-fpm?style=flat-square
