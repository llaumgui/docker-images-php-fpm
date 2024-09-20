#!/bin/sh

if [ -d /var/www/apps/previewgenerator ]; then
    if [ -z "${HEALTHCHECKS_PREVIEW_URL}" ]; then
        php -f /var/www/occ preview:pre-generate
    else
        curl -fsS -m 10 --retry 5 -o /dev/null ${HEALTHCHECKS_NC_URL}/start && \
        php -f /var/www/occ preview:pre-generate && \
        curl -fsS -m 10 --retry 5 -o /dev/null ${HEALTHCHECKS_NC_URL}
    fi
fi
