# PHP 7.1 (PHP-FPM) on alpine Linux

PHP 7.1 image:
* Forked from [official PHP-FPM build with alpine Linux](https://store.docker.com/images/php) (php:7.1-fpm-alpine).
* Additionals PHP extensions:
 * bcmath
 * gd
 * intl
 * mbstring
 * opcache
 * xmlrpc
* Additionals binaries:
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
 
* Capacity to set UID and GID for php-cli usage

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
  llaumgui/php:7.1-fpm
~~~

### With compose
You can use this container in a docker-compose.yml file:
~~~yaml
  php71:
    container_name: php71
    image: llaumgui/php:7.1-fpm
    restart: always
    volumes:
     - /etc/localtime:/etc/localtime:ro
     - /var/www:/var/www
    expose:
     - 9000
~~~

## Rebuild with less extensions
~~~yaml
  php71:
    container_name: php:7.1-fpm
    image: llaumgui/php:7.1-fpm
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
		DOCKER_USER_UID: 1000
		DOCKER_USER_GID:1000
    restart: always
    volumes:
     - /etc/localtime:/etc/localtime:ro
     - /var/www:/var/www
    expose:
     - 9000
~~~
