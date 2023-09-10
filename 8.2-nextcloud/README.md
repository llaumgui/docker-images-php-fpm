# PHP 8.2-nextcloud (PHP-FPM) on Debian (GLibC)

[![Author][ico-twitter]][link-twitter]
[![Build Status][ico-ghactions]][link-ghactions]
[![Docker Pull][ico-docker]][link-docker]
[![Latest Version][ico-version]][link-docker]
[![Software License][ico-license]](LICENSE)

PHP 8.2-nextcloud image:

* Forked from [official Nextcloud](https://github.com/nextcloud/docker/blob/09fecda4067434c11f955cdd3000ed950fe48d04/27/fpm/Dockerfile) (nextcloud:fpm).
* Using Debian with GLibC used by [reconize](https://github.com/nextcloud/recognize) for native speed.
* Additionals PHP extensions:
  * intl
* Additionals binaries:
  * GIT
  * [php-fpm-healthcheck](https://github.com/renatomefi/php-fpm-healthcheck)
* Some configuration:
  * A dedicated php-cli.ini.

## Usage

### With docker client

You can run this container with docker client:

~~~bash
docker run -d \
  --volumes /docker/volumes/www:/var/www \
  --expose 9000 \
  llaumgui/php:8.2-nextcloud
~~~

### With compose

You can use this container in a docker-compose.yml file:

~~~yaml
  php82:
    container_name: php82
    image: llaumgui/php:8.2-nextcloud
    restart: always
    environment:
      TZ: 'Europe/Paris'
    volumes:
     - /var/www:/var/www
    expose:
     - 9000
~~~

[ico-twitter]: https://img.shields.io/static/v1?label=Author&message=llaumgui&color=50ABF1&logo=twitter&style=flat-square
[link-twitter]: https://twitter.com/llaumgui
[ico-docker]: https://img.shields.io/docker/pulls/llaumgui/php?color=%2496ed&logo=docker&style=flat-square
[link-docker]: https://hub.docker.com/r/llaumgui/php
[ico-ghactions]: https://img.shields.io/github/workflow/status/llaumgui/docker-images-php-fpm/Docker%20image%20CI%20CD?style=flat-square&logo=github&label=CI/CD
[link-ghactions]: https://github.com/llaumgui/docker-images-php-fpm/actions
[ico-version]: https://img.shields.io/docker/v/llaumgui/php?sort=semver&color=%2496ed&logo=docker&style=flat-square
[ico-license]: https://img.shields.io/github/license/llaumgui/docker-images-php-fpm?style=flat-square
