# Apache
FROM centos:7
MAINTAINER Guillaume Kulakowski <guillaume@kulakowski.fr>

LABEL Description="Sphinx Search Engine 2"
LABEL Vendor="Guillaume Kulakowski"
LABEL License=MIT
LABEL Version=2-1.0

EXPOSE 9312

# Install EPEL.
RUN yum localinstall -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

# Install Sphinx SE from EPEL.
RUN yum update -y && yum install -y sphinx
RUN yum clean all

# Simple startup script to avoid some issues observed with container restart.
ADD files/run-sphinx.sh /run-sphinx.sh
RUN chmod -v +x /run-sphinx.sh

CMD ["/run-sphinx.sh"]