#!/bin/bash

CONFIG=/etc/sphinx/sphinx.conf

# Make sure we're not confused by old, incompletely-shutdown sphinx
# context after restarting the container.llaumgui/centos7-scl-php56https://www.softwarecollections.org/en/scls/rhscl/rh-php56/
rm -rf /var/run/sphinx/*

echo "### Make indexation (in rotate mode) ###"
/usr/bin/indexer --config ${CONFIG} --rotate --all

echo "### Run Sphinx Daemon ###"
/usr/bin/searchd --config ${CONFIG} --safetrace --nodetach