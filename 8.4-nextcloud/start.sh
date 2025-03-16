#!/bin/sh
set -e

DEFAULT_UID=33
DEFAULT_GID="${DEFAULT_UID}"

# Change UID and GID of www-data to match the host
if [ "${PUID}" -ne "${DEFAULT_UID}" ]; then
    usermod -u ${PUID} www-data
fi
if [ "${PGID}" -ne "${DEFAULT_GID}" ]; then
    groupmod -g ${PGID} www-data
fi

# Fix ownership of /var/www/html

# Start supervisor
/usr/bin/supervisord -c /etc/supervisor/supervisord.conf
