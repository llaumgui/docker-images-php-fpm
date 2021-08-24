# PHP 8.0 (PHP-FPM) on alpine Linux

[![Docker Pulls](https://img.shields.io/docker/pulls/llaumgui/php.svg)](https://hub.docker.com/r/llaumgui/php/) [![](https://images.microbadger.com/badges/image/llaumgui/php.svg)](https://microbadger.com/images/llaumgui/php "Get your own image badge on microbadger.com") [![](https://images.microbadger.com/badges/version/llaumgui/php.svg)](https://microbadger.com/images/llaumgui/php "Get your own version badge on microbadger.com") [![](https://images.microbadger.com/badges/commit/llaumgui/php.svg)](https://microbadger.com/images/llaumgui/php "Get your own commit badge on microbadger.com")  [![](https://img.shields.io/github/last-commit/llaumgui/docker-images.svg)](https://github.com/llaumgui/docker-images)

PHP 8.0 image:

* Forked from [official PHP-FPM build with alpine Linux](https://store.docker.com/images/php) (php:8.0-fpm-alpine).
* Additionals PHP extensions:
  * bcmath
  * gd
  * gmp
  * intl
  * mbstring
  * opcache
  * xmlrpc
* Additionals binaries:
  * GIT
  * [php-fpm-healthcheck](https://github.com/renatomefi/php-fpm-healthcheck)
* Capability to disable some additionals extensions (need rebuild and pass build arg):
  * APCu
  * exif
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
  llaumgui/php:8.0-fpm
~~~

### With compose

You can use this container in a docker-compose.yml file:

~~~yaml
  php80:
    container_name: php80
    image: llaumgui/php:8.0-fpm
    restart: always
    volumes:
     - /etc/localtime:/etc/localtime:ro
     - /var/www:/var/www
    expose:
     - 9000
~~~

## Rebuild with less extensions

~~~yaml
  php80:
    container_name: php:8.0-fpm
    image: llaumgui/php:8.0-fpm
    build:
      context: ../PATH_TO_DOCKERFILE/
      args:
        DOCKER_PHP_ENABLE_APCU: 'off'
        DOCKER_PHP_ENABLE_COMPOSER: 'off'
        DOCKER_PHP_ENABLE_EXIF: 'off'
        DOCKER_PHP_ENABLE_IMAGICK: 'off'
        DOCKER_PHP_ENABLE_LDAP: 'off'
        DOCKER_PHP_ENABLE_MEMCACHED: 'off'
        DOCKER_PHP_ENABLE_MONGODB: 'off'
        DOCKER_PHP_ENABLE_MYSQL: 'off'
        DOCKER_PHP_ENABLE_POSTGRESQL: 'off'
        DOCKER_PHP_ENABLE_REDIS: 'off'
        DOCKER_PHP_ENABLE_SYMFONY: 'off'
        DOCKER_PHP_ENABLE_XDEBUG: 'off'
    restart: always
    volumes:
     - /etc/localtime:/etc/localtime:ro
     - /var/www:/var/www
    expose:
     - 9000
~~~
