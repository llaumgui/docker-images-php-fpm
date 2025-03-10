# PHP 8.4-nextcloud (PHP-FPM) on Debian (GLibC)

[![Build Status][ico-ghactions]][link-ghactions]
[![Docker Pulls][ico-docker]][link-docker]
[![Latest Version][ico-version]][link-docker]
[![License][ico-license]](LICENSE)

> ⚠ **Warning:** This image is a **PHP-FPM** container and does **not** include Nextcloud.  
> - Nextcloud must be mounted separately using a Docker volume to allow updates via the web-based update process.  
> - A web server such as **[Apache](https://github.com/llaumgui/docker-images-httpd/)** is required to serve Nextcloud.

## Features

* Forked from the official PHP-FPM build with Debian Linux (`php:8.4-fpm`).  
  **Uses Debian with GLibC for [Recognize](https://github.com/nextcloud/recognize) with *native speed mode*.**
* Inspired by the [official Nextcloud image](https://github.com/nextcloud/docker/blob/09fecda4067434c11f955cdd3000ed950fe48d04/27/fpm/Dockerfile) (`nextcloud:fpm`).
* **Includes several optimizations** to enhance performance and reliability.
* Utilizes [Supervisor](http://supervisord.org/) to manage multiple processes.

### Implements cron jobs
* Runs the Nextcloud cron job every 5 minutes.
* Runs `preview:pre-generate` cron job every 10 minutes if [Preview Generator](https://github.com/nextcloud/previewgenerator) is present.
* Automatically updates extensions daily if `NC_EXT_UPDATE` is defined.
* Includes [Healthcheck](https://healthchecks.io/).
  * Nextcloud cron job configured via `HEALTHCHECKS_NC_URL`.
  * Preview Generator job configured via `HEALTHCHECKS_PREVIEW_URL`.
  * Automatic daily updates configured via `HEALTHCHECKS_UPDATE_URL`.

### Full-Text Search Support
Includes [Full Text Search](https://apps.nextcloud.com/apps/fulltextsearch) support:
* Installs [Tesseract](https://github.com/tesseract-ocr/tesseract) and [OCRmyPDF](https://ocrmypdf.readthedocs.io/en/latest/) for OCR capabilities.
* Enables `occ fulltextsearch:live` for automatic indexing of new content (only if Full Text Search is present).

### Additional Features
* **Additional Binaries:**
  * Git.
  * [php-fpm-healthcheck](https://github.com/renatomefi/php-fpm-healthcheck).
  * Python and `python3-venv` for [Local Large Language Model](https://apps.nextcloud.com/apps/llm).
  * NodeJS for [Recognize](https://github.com/nextcloud/recognize) and [pageres-cli](https://github.com/sindresorhus/pageres-cli).
  * [pageres-cli](https://github.com/sindresorhus/pageres-cli) for website screenshot generation.
* **Configuration:**
  * Recommended APCu configuration.
  * Recommended igbinary configuration.
  * Recommended OPCache configuration.
  * Recommended Postgres configuration.
  * Recommended Security configuration.
  * A dedicated `php-cli.ini`

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

| Variable                   | Description                                       | Default Value   |
|----------------------------|---------------------------------------------------|----------------|
| `TZ`                       | Timezone configuration                            |                |
| `HEALTHCHECKS_NC_URL`      | Healthcheck URL for Nextcloud cron job            | `false`        |
| `HEALTHCHECKS_PREVIEW_URL` | Healthcheck URL for Preview Generator job         | `false`        |
| `HEALTHCHECKS_UPDATE_URL`  | Healthcheck URL for automatic updates             | `false`        |
| `NC_EXT_UPDATE`            | Enable automatic extension updates (`true/false`) | `false`        |

## Full stack Docker Compose example

ToDo.

You can use this container in a docker-compose.yml file:

~~~yaml
  php84:
    container_name: php84
    image: llaumgui/php:8.4-nextcloud
    restart: always
    environment:
      TZ: 'Europe/Paris'
      HEALTHCHECKS_NC_URL: 'https://healthchecks.io/ping/c6ff4460-abc7-41ce-8e33-a671f17b9319'
    volumes:
     - /var/www:/var/www
    expose:
     - 9000
~~~

[ico-docker]: https://img.shields.io/docker/pulls/llaumgui/php?color=%2496ed&logo=docker&style=flat-square
[link-docker]: https://hub.docker.com/r/llaumgui/php
[ico-ghactions]: https://img.shields.io/github/actions/workflow/status/llaumgui/docker-images-php-fpm/devops.yml?branch=main&style=flat-square&logo=github&label=CI/CD
[link-ghactions]: https://github.com/llaumgui/docker-images-php-fpm/actions
[ico-version]: https://img.shields.io/docker/v/llaumgui/php?sort=semver&color=%2496ed&logo=docker&style=flat-square
[ico-license]: https://img.shields.io/github/license/llaumgui/docker-images-php-fpm?style=flat-square
