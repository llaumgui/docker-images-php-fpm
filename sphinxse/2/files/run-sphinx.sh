#!/bin/bash

CONFIG=/etc/sphinx/sphinx.conf
DATA_DIR=/var/lib/sphinx

# Make sure we're not confused by old, incompletely-shutdown sphinx
# context after restarting the container.llaumgui/centos7-scl-php56https://www.softwarecollections.org/en/scls/rhscl/rh-php56/
rm -rf /var/run/sphinx/*

if ls ${DATA_DIR}/*.sph 1> /dev/null 2>&1; then
    echo "### Make indexation (in rotate mode) ###"
    /usr/bin/indexer --config ${CONFIG} --rotate --all
else
    echo "### Make full indexation (first) ###"
    /usr/bin/indexer --config ${CONFIG} --all
fi

echo "### Run Sphinx Daemon ###"
/usr/bin/searchd --config ${CONFIG} --safetrace --nodetach