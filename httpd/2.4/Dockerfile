# Apache
FROM centos:7
MAINTAINER Guillaume Kulakowski <guillaume@kulakowski.fr>

LABEL Description="CentOS HTTPd 2.4.12 from SCL"
LABEL Vendor="Guillaume Kulakowski"
LABEL License=MIT
LABEL Version=2.4-1.0

EXPOSE 80

# Install HTTPD24 collection from SCL.
RUN yum localinstall -y https://www.softwarecollections.org/en/scls/rhscl/httpd24/epel-7-x86_64/download/rhscl-httpd24-epel-7-x86_64.noarch.rpm

# Install HTTPd 2.4 from SCL.
RUN yum update -y && yum install -y httpd24 \
  httpd24-httpd-tools && yum clean all

# Symlink.
RUN ln -s /opt/rh/httpd24/root/etc/httpd/ /etc

# My configuration.
COPY conf.d /etc/httpd/conf.d
RUN mkdir /etc/httpd/vhost.d
RUN rm -f /etc/httpd/conf.d/welcome.conf

# Simple startup script to avoid some issues observed with container restart.
ADD files/run-httpd.sh /run-httpd.sh
RUN chmod -v +x /run-httpd.sh

WORKDIR /var/www

CMD ["/run-httpd.sh"]
