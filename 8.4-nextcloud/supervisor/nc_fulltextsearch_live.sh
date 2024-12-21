#!/bin/sh

# If fulltextsearch is present: stop all running indexes before start live.
[ -d /var/www/apps/fulltextsearch ] && php /var/www/occ fulltextsearch:stop

# If fulltextsearch is present: start live index
[ -d /var/www/apps/fulltextsearch ] && php /var/www/occ fulltextsearch:live
