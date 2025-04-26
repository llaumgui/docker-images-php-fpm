#!/bin/sh
set -e

FILE_DONE="/init-uid-gid.done"
DEFAULT_UID=33
DEFAULT_GID="${DEFAULT_UID}"

if [ ! -e "${FILE_DONE}" ]; then
    # Change UID and GID of www-data to match the host
    if [ "${PUID}" -ne "${DEFAULT_UID}" ]; then
        usermod -u ${PUID} www-data
    fi
    if [ "${PGID}" -ne "${DEFAULT_GID}" ]; then
        groupmod -g ${PGID} www-data
    fi
    touch "${FILE_DONE}"
fi

