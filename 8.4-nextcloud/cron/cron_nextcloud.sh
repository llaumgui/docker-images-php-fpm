#!/bin/sh

if [ -z "${HEALTHCHECKS_NC_URL}" ]; then
    php -f /var/www/cron.php
else
    curl -fsS -m 10 --retry 5 -o /dev/null ${HEALTHCHECKS_NC_URL}/start && \
    php -f /var/www/cron.php && \
    curl -fsS -m 10 --retry 5 -o /dev/null ${HEALTHCHECKS_NC_URL}
fi
