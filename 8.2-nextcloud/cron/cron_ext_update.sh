#!/bin/sh

if [ -n "${NC_EXT_UPDATE}" ]; then
    if [ -z "${HEALTHCHECKS_UPDATE_URL}" ]; then
        php -f /var/www/occ app:update --all
    else
        curl -fsS -m 10 --retry 5 -o /dev/null ${HEALTHCHECKS_UPDATE_URL}/start && \
        php -f /var/www/occ app:update --all && \
        curl -fsS -m 10 --retry 5 -o /dev/null ${HEALTHCHECKS_UPDATE_URL}
    fi
fi
