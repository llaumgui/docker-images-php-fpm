# PHP 7.2 (PHP-FPM) on alpine Linux

PHP 7.2 image:
* Forked from [official PHP-FPM build with alpine Linux](https://store.docker.com/images/php) (php:7.2-fpm-alpine).
* Additionals PHP extensions:
 * bcmath
 * gd
 * intl
 * mbstring
 * opcache
 * xmlrpc
* Additionals binaries:
 * [php-fpm-cli](https://gist.githubusercontent.com/muhqu/91497df3a110f594b992/raw/58bf4ee037b637c24dea2f80a8c6735d5229f4d6/php-fpm-cli).
 * *apcu_clear_cache*: script to purge APCu's cache.
 * ImageMagick
 * GIT

* Capability to disable some additionals extensions (need rebuild and pass build arg):
 * APCu
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

* Some configuration:
 * A dedicated php-cli.ini.

## Usage
### With docker client
You can run this container with docker client:
~~~bash
docker run -d \
  --volumes /etc/localtime:/etc/localtime:ro \
  --volumes /docker/volumes/www:/var/www \
  --volumes /docker/volumes/php56/log:/var/log/php-fpm \
  --expose 9000 \
  llaumgui/php:7.2-fpm
~~~

### With compose
You can use this container in a docker-compose.yml file:
~~~yaml
  php72:
    container_name: php72
    image: llaumgui/php:7.2-fpm
    restart: always
    volumes:
     - /etc/localtime:/etc/localtime:ro
     - /var/www:/var/www
    expose:
     - 9000
~~~

## Rebuild with less extensions
~~~yaml
  php72:
    container_name: php:7.2-fpm
    image: llaumgui/php:7.2-fpm
    build: 
      context: ../PATH_TO_DOCKERFILE/
      args:
        DOCKER_PHP_ENABLE_APCU: 'off'
        DOCKER_PHP_ENABLE_COMPOSER: 'off'
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
