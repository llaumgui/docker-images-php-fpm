#!/bin/sh

echo "**** installing tesseract-ocr-fra ****"
apt-get update
apt-get install --no-install-recommends -y \
    tesseract-ocr-fra

rm -rf /var/lib/apt/lists/*
