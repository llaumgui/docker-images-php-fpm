# CentOS HTTPd 2.4.12
An Apache 2.4 from [Software Collections](https://www.softwarecollections.org/en/scls/rhscl/httpd24/) build on [CentOS 7](https://hub.docker.com/_/centos/).

HTTPd 2.4.12 image build with:
* [CentOS 7](https://hub.docker.com/_/centos/).
* [HTTPd 2.4.12 from Software Collections](https://www.softwarecollections.org/en/scls/rhscl/httpd24/) (SCL).

With configuration:
* [Deflate](https://github.com/llaumgui/docker-config/blob/master/build/httpd/2.4/conf.d/deflate.conf).
* [ETags](https://github.com/llaumgui/docker-config/blob/master/build/httpd/2.4/conf.d/etags.conf).
* [Expires](https://github.com/llaumgui/docker-config/blob/master/build/httpd/2.4/conf.d/expires.conf).
* [Security](https://github.com/llaumgui/docker-config/blob/master/build/httpd/2.4/conf.d/security.conf).
* You can put your vhost in _/etc/httpd/vhost.d_ (This directory can be shared with the host).

Work also with
* [PHP-FPM](https://github.com/llaumgui/docker-config/blob/master/build/httpd/2.4/conf.d/php.conf) handler toward *llaumgui_centos7-scl-php56-fpm*.