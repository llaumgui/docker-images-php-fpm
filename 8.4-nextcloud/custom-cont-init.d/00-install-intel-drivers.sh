#!/bin/sh

echo "**** installing intel-media-va-driver-non-free ****"
apt-get update
apt-get install --no-install-recommends -y \
    intel-media-va-driver \
    vainfo

rm -rf /var/lib/apt/lists/*
