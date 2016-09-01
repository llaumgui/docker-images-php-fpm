# CentOS PHP 5.6
An PHP 5.6 container using [Software Collections rh-php56](https://www.softwarecollections.org/en/scls/rhscl/rh-php56/) build from [CentOS 7](https://hub.docker.com/_/centos/).

PHP 5.6 image build with:
* [CentOS 7](https://hub.docker.com/_/centos/).
* [PHP 5.6 from Software Collections](https://www.softwarecollections.org/en/scls/rhscl/rh-php56/) (SCL).
* A running PHP-FPM daemon.
* PHP-CLI capabilities:
 * A _/usr/bin/php_ command using SCL.
 * [Composer](http://getcomposer.org/).
 * [Drush](http://www.drush.org/).
 * [php-fpm-cli](https://gist.githubusercontent.com/muhqu/91497df3a110f594b992/raw/58bf4ee037b637c24dea2f80a8c6735d5229f4d6/php-fpm-cli).
 * A dedicated php-cli.ini.
 * A purge_cache script to purge APCu's cache.

## Usage
### With docker client
You can run this container with docker client:
~~~bash
docker run -d \
  --volumes /etc/localtime:/etc/localtime:ro \
  --volumes /docker/volumes/www:/var/www \
  --volumes /docker/volumes/php56/log:/var/log/php-fpm \
  --expose 9000 \
  llaumgui/centos7-scl-php56
~~~

### With compose
You can use this container in a docker-compose.yml file:
~~~yaml
  php56:
    container_name: php56
    image: llaumgui/centos7-scl-php56
    restart: always
    mem_limit: 2g
    volumes:
     - /etc/localtime:/etc/localtime:ro
     - /docker/volumes/www:/var/www
     - /docker/volumes/php56/log:/var/log/php-fpm
    expose:
     - 9000
~~~