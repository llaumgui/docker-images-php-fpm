#!/bin/sh
set -e

# Idea and code inspired from https://www.linuxserver.io/ under the GPLv3 license.
# https://github.com/linuxserver/docker-baseimage-debian/blob/master/root/etc/s6-overlay/s6-rc.d/init-custom-files/run

# Directories
SCRIPTS_DIR="/custom-cont-init.d"
FILE_DONE="/init-custom-files.done"

if [ ! -e "${FILE_DONE}" ]; then
    # Make sure custom init directory exists and has files in it
    if [ -e "${SCRIPTS_DIR}" ] && [ -n "$(/bin/ls -A ${SCRIPTS_DIR} 2>/dev/null)" ]; then
        echo "[custom-init] Files found, executing"
        for SCRIPT in "${SCRIPTS_DIR}"/*; do
            NAME="$(basename "${SCRIPT}")"
            if [ -f "${SCRIPT}" ]; then
                echo "[custom-init] ${NAME}: executing..."
                /bin/bash "${SCRIPT}"
                echo "[custom-init] ${NAME}: exited $?"
            elif [ ! -f "${SCRIPT}" ]; then
                echo "[custom-init] ${NAME}: is not a file"
            fi
        done
    else
        echo "[custom-init] No custom files found, skipping..."
    fi
    touch "${FILE_DONE}"
fi
