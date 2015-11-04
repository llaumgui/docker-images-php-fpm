#!/bin/bash
# Inspired from https://github.com/CentOS/CentOS-Dockerfiles/blob/master/httpd/centos7/run-httpd.sh

SCL_NAME=httpd24
SCL_PATH="/opt/rh/${SCL_NAME}/root"

# Make sure we're not confused by old, incompletely-shutdown httpd
# context after restarting the container.  httpd won't start correctly
# if it thinks it is already running.
rm -rf ${SCL_PATH}/var/run/httpd/* /tmp/httpd* ${SCL_PATH}/tmp/httpd*

scl enable ${SCL_NAME} "exec httpd -D FOREGROUND"