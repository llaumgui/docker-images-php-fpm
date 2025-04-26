#!/bin/sh
set -e

# Init UID and GID from PUID and PGID
/bin/init-uid-gid.sh

# Init with custom files
/bin/init-custom-files.sh

# Start supervisor
/usr/bin/supervisord -c /etc/supervisor/supervisord.conf
