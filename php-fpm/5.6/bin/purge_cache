#!/bin/bash

FPM_PORT=9000
FPM_IP=127.0.0.1

php-fpm-cli -r 'apcu_clear_cache();' -connect ${FPM_IP}:${FPM_PORT}