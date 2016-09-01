# CentOS HTTPd 2.4.12
An Apache 2.4 from [Software Collections](https://www.softwarecollections.org/en/scls/rhscl/httpd24/) build on [CentOS 7](https://hub.docker.com/_/centos/).

HTTPd 2.4.12 image build with:
* [CentOS 7](https://hub.docker.com/_/centos/).
* [HTTPd 2.4.12 from Software Collections](https://www.softwarecollections.org/en/scls/rhscl/httpd24/) (SCL).

With configuration:
* [Deflate](https://github.com/llaumgui/docker-images/tree/master/httpd/2.4/conf.d/deflate.conf).
* [ETags](https://github.com/llaumgui/docker-images/tree/master/httpd/2.4/conf.d/etags.conf).
* [Expires](https://github.com/llaumgui/docker-images/tree/master/httpd/2.4/conf.d/expires.conf).
* [Security](https://github.com/llaumgui/docker-images/tree/master/httpd/2.4/conf.d/security.conf).
* You can put your vhost in _/etc/httpd/vhost.d_ (This directory can be shared with the host).

Work also with
* [PHP-FPM](https://github.com/llaumgui/docker-images/tree/master/httpd/2.4/conf.d/php.conf) handler toward *php* hostname.

## Usage
### With docker client
You can run this container with docker client:
~~~bash
docker run -d \
  --volumes /etc/localtime:/etc/localtime:ro \
  --volumes /docker/volumes/www:/var/www \
  --volumes /docker/volumes/httpd24/conf/vhost.d:/etc/httpd/vhost.d:ro \
  --volumes /docker/volumes/httpd24/conf/ssl:/etc/httpd/ssl:ro \
  --volumes /docker/volumes/httpd24/log:/var/log/httpd24 \
  -p 80:80 \
  -p 443:443 \
  llaumgui/centos7-scl-httpd24
~~~

### With compose
You can use this container in a docker-compose.yml file:
~~~yaml
  httpd24:
    container_name: httpd24
    image: llaumgui/centos7-scl-httpd24
    restart: always
    mem_limit: 512g
    volumes:
     - /etc/localtime:/etc/localtime:ro
     - /docker/volumes/www:/var/www/
     - /docker/volumes/httpd24/conf/vhost.d:/etc/httpd/vhost.d:ro
     - /docker/volumes/httpd24/conf/ssl:/etc/httpd/ssl:ro
     - /docker/volumes/httpd24/log:/var/log/httpd24
    ports:
     - "80:80"
     - "443:443"
~~~