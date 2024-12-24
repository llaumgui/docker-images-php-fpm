# PHP 8.3-nextcloud (PHP-FPM) on Debian (GLibC)

[![Author][ico-twitter]][link-twitter]
[![Build Status][ico-ghactions]][link-ghactions]
[![Docker Pull][ico-docker]][link-docker]
[![Latest Version][ico-version]][link-docker]
[![Software License][ico-license]](LICENSE)

PHP 8.3-nextcloud image:

* Based on [official Nextcloud](https://github.com/nextcloud/docker/blob/09fecda4067434c11f955cdd3000ed950fe48d04/27/fpm/Dockerfile) (nextcloud:fpm).
* Use Debian with GLibC for [reconize](https://github.com/nextcloud/recognize) with **native speed mode**.
* Use [Supervisor](http://supervisord.org/) to launch several process.
* Implement cron.
  * Implement [Healthcheck](https://healthchecks.io/).
  * Nextcloud cron every 5mn (use Healthcheck: `HEALTHCHECKS_NC_URL`).
  * Auto-update extensions (use Healthcheck: `HEALTHCHECKS_UPDATE_URL`) if `NC_EXT_UPDATE` is defined.
* Add [Full text search](https://apps.nextcloud.com/apps/fulltextsearch) support:
  * Install [Tesseract](https://github.com/tesseract-ocr/tesseract) and [OCRmyPDF](https://ocrmypdf.readthedocs.io/en/latest/) for OCR.
  * Run `occ:fulltextsearch:live` to auto index new contents.
* Additionals PHP extensions:
  * intl.
* Additionals binaries:
  * GIT.
  * [php-fpm-healthcheck](https://github.com/renatomefi/php-fpm-healthcheck).
  * Python and python3-venv for [Local Large language model](https://apps.nextcloud.com/apps/llm).
* Some configuration:
  * A dedicated php-cli.ini.

## Usage

### With docker client

You can run this container with docker client:

~~~bash
docker run -d \
  --volumes /docker/volumes/www:/var/www \
  --expose 9000 \
  llaumgui/php:8.3-nextcloud
~~~

### With compose

You can use this container in a docker-compose.yml file:

~~~yaml
  php83:
    container_name: php83
    image: llaumgui/php:8.3-nextcloud
    restart: always
    environment:
      TZ: 'Europe/Paris'
      HEALTHCHECKS_NC_URL: 'https://healthchecks.io/ping/c6ff4460-abc7-41ce-8e33-a671f17b9319'
    volumes:
     - /var/www:/var/www
    expose:
     - 9000
~~~

[ico-twitter]: https://img.shields.io/static/v1?label=Author&message=llaumgui&color=000&logo=x&style=flat-square
[link-twitter]: https://twitter.com/llaumgui
[ico-docker]: https://img.shields.io/docker/pulls/llaumgui/php?color=%2496ed&logo=docker&style=flat-square
[link-docker]: https://hub.docker.com/r/llaumgui/php
[ico-ghactions]: https://img.shields.io/github/actions/workflow/status/llaumgui/docker-images-php-fpm/devops.yml?branch=main&style=flat-square&logo=github&label=CI/CD
[link-ghactions]: https://github.com/llaumgui/docker-images-php-fpm/actions
[ico-version]: https://img.shields.io/docker/v/llaumgui/php?sort=semver&color=%2496ed&logo=docker&style=flat-square
[ico-license]: https://img.shields.io/github/license/llaumgui/docker-images-php-fpm?style=flat-square
