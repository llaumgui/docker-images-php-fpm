# My httpd image, based on alpine Linux, configured and forked from the
# official HTTPd docker repository.
# @see: https://store.docker.com/images/httpd
FROM httpd:2.4-alpine
MAINTAINER Guillaume Kulakowski <guillaume@kulakowski.fr>

LABEL Description="Fork of httpd:2.4-alpine"
LABEL Vendor="Guillaume Kulakowski"
LABEL License="MIT"
LABEL Version=2.4-alpine

# Enable some modules.
RUN sed -i 's@^#LoadModule deflate_module modules/mod_deflate.so@LoadModule deflate_module modules/mod_de
    sed -i 's@^#LoadModule expires_module modules/mod_expires.so@LoadModule expires_module modules/mod_ex
    sed -i 's@^#LoadModule ssl_module modules/mod_ssl.so@LoadModule ssl_module modules/mod_ssl.so@g'
    sed -i 's@^#LoadModule rewrite_module modules/mod_rewrite.so@LoadModule rewrite_module modules/mod_re
    sed -i 's@^#LoadModule proxy_module modules/mod_proxy.so@LoadModule proxy_module modules/mod_proxy.so
    sed -i 's@^#LoadModule proxy_http_module modules/mod_proxy_http.so@LoadModule proxy_http_module modul
    sed -i 's@^#LoadModule socache_shmcb_module modules/mod_socache_shmcb.so@LoadModule socache_shmcb_mod

# Use 443
RUN sed -i 's@Listen 80@Listen 80\nListen 443@g' /usr/local/apache2/conf/httpd.conf

# Custom configuration.
RUN mkdir /usr/local/apache2/conf/conf.d && \
    mkdir /usr/local/apache2/conf/vhost.d && \
    mkdir /usr/local/apache2/conf/ssl && \
    echo 'IncludeOptional conf/conf.d/*.conf' >> /usr/local/apache2/conf/httpd.conf
COPY conf.d /usr/local/apache2/conf/conf.d

EXPOSE 443
WORKDIR /var/www