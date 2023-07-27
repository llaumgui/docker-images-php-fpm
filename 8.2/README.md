# PHP 8.2 (PHP-FPM) on alpine Linux

[![Author][ico-twitter]][link-twitter]
[![Build Status][ico-ghactions]][link-ghactions]
[![Docker Pull][ico-docker]][link-docker]
[![Latest Version][ico-version]][link-docker]
[![Software License][ico-license]](LICENSE)

PHP 8.2 image:

* Forked from [official PHP-FPM build with alpine Linux](https://store.docker.com/images/php) (php:8.2-fpm-alpine).
* Additionals PHP extensions:
  * bcmath
  * gd
  * gmp
  * intl
  * mbstring
  * opcache
  * shmop
  * xmlrpc
* Additionals binaries:
  * GIT
  * [php-fpm-healthcheck](https://github.com/renatomefi/php-fpm-healthcheck)
* Capability to disable some additionals extensions (need rebuild and pass build arg):
  * APCu
  * exif
  * ffmpeg
  * imagick
  * ldap
  * memcached
  * mongodb
  * mysql
  * postgresql
  * redis
  * Symfony (currently only yaml)
  * xDebug
* Capability to disable some binaries (need rebuild and pass build arg):
  * Composer
  * ImageMagick (with optionnal imagick support)
* Some configuration:
  * A dedicated php-cli.ini.

## Usage

### With docker client

You can run this container with docker client:

~~~bash
docker run -d \
  --volumes /etc/localtime:/etc/localtime:ro \
  --volumes /docker/volumes/www:/var/www \
  --expose 9000 \
  llaumgui/php:8.2-fpm
~~~

### With compose

You can use this container in a docker-compose.yml file:

~~~yaml
  php82:
    container_name: php82
    image: llaumgui/php:8.2-fpm
    restart: always
    environment:
      TZ: 'Europe/Paris'
    volumes:
     - /etc/localtime:/etc/localtime:ro
     - /var/www:/var/www
    expose:
     - 9000
~~~

## Rebuild with less extensions

~~~yaml
  php82:
    container_name: php:8.2-fpm
    image: llaumgui/php:8.2-fpm
    build:
      context: ../PATH_TO_DOCKERFILE/
      args:
        DOCKER_PHP_ENABLE_APCU: 'off'
        DOCKER_PHP_ENABLE_COMPOSER: 'off'
        DOCKER_PHP_ENABLE_EXIF: 'off'
        DOCKER_PHP_ENABLE_IMAGICK: 'off'
        DOCKER_PHP_ENABLE_FFMPEG: 'onf'
        DOCKER_PHP_ENABLE_LDAP: 'off'
        DOCKER_PHP_ENABLE_MEMCACHED: 'off'
        DOCKER_PHP_ENABLE_MONGODB: 'off'
        DOCKER_PHP_ENABLE_MYSQL: 'off'
        DOCKER_PHP_ENABLE_POSTGRESQL: 'off'
        DOCKER_PHP_ENABLE_REDIS: 'off'
        DOCKER_PHP_ENABLE_SYMFONY: 'off'
        DOCKER_PHP_ENABLE_XDEBUG: 'off'
    restart: always
    environment:
      TZ: 'Europe/Paris'
    volumes:
     - /etc/localtime:/etc/localtime:ro
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
