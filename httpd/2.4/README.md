# Alpine HTTPd 2.4
An Apache 2.4 image forked from offical [repository](https://store.docker.com/images/httpd).

With configuration:
* [Deflate](https://github.com/llaumgui/docker-images/tree/master/httpd/2.4/conf.d/deflate.conf).
* [ETags](https://github.com/llaumgui/docker-images/tree/master/httpd/2.4/conf.d/etags.conf).
* [Expires](https://github.com/llaumgui/docker-images/tree/master/httpd/2.4/conf.d/expires.conf).
* [Security](https://github.com/llaumgui/docker-images/tree/master/httpd/2.4/conf.d/security.conf).
* SSL support.
* You can put your vhost in _/usr/local/apache2/conf/vhost.d_ (This directory can be shared with the host).

Work also with
* [PHP-FPM](https://github.com/llaumgui/docker-images/tree/master/httpd/2.4/conf.d/php.conf) handler toward *php* hostname.

## Usage
### With docker client
You can run this container with docker client:
~~~bash
docker run -d \
  --volumes /etc/localtime:/etc/localtime:ro \
  --volumes /docker/volumes/www:/var/www \
  --volumes /docker/volumes/httpd24/conf/vhost.d:/usr/local/apache2/conf/vhost.d:ro \
  --volumes /docker/volumes/httpd24/conf/ssl://usr/local/apache2/conf/ssl:ro \
  -p 80:80 \
  -p 443:443 \
  llaumgui/httpd24
~~~

### With compose
You can use this container in a docker-compose.yml file:
~~~yaml
  httpd:
    container_name: httpd
    image: llaumgui/httpd24
    restart: always
    volumes:
     - /etc/localtime:/etc/localtime:ro
     - /docker/volumes/www:/var/www/
     - /docker/volumes/httpd24/conf/vhost.d:/usr/local/apache2/conf/vhost.d:ro
     - /docker/volumes/httpd24/conf/ssl:/usr/local/apache2/conf/ssl:ro
    ports:
     - "80:80"
     - "443:443"
~~~