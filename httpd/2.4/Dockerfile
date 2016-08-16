# Apache Container
FROM centos:7
MAINTAINER Guillaume Kulakowski <guillaume@kulakowski.fr>

LABEL Description="CentOS HTTPd 2.4.12 from SCL"
LABEL Vendor="Guillaume Kulakowski"
LABEL License=MIT
LABEL Version=2.4-1.1

# Install HTTPD24 collection from SCL.
RUN yum update -y && \
    yum install -y centos-release-scl && \
    yum install -y httpd24 \
                   httpd24-httpd-tools \
                   httpd24-mod_ssl && \
    yum clean all

# Symlink.
RUN ln -s /opt/rh/httpd24/root/etc/httpd/ /etc

# My configuration.
COPY conf.d /etc/httpd/conf.d
RUN mkdir /etc/httpd/vhost.d
RUN rm -f /etc/httpd/conf.d/welcome.conf

# Use MPM event.
RUN sed -i 's/LoadModule mpm_prefork_module/#LoadModule mpm_prefork_module/g' /etc/httpd/conf.modules.d/00-mpm.conf && \
    sed -i 's/#LoadModule mpm_event_module/LoadModule mpm_event_module/g' /etc/httpd/conf.modules.d/00-mpm.conf

# Simple startup script to avoid some issues observed with container restart.
ADD files/run-httpd.sh /run-httpd.sh
RUN chmod -v +x /run-httpd.sh

EXPOSE 80
EXPOSE 443
WORKDIR /var/www

CMD ["/run-httpd.sh"]