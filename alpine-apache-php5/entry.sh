#!/bin/sh
umask 0022
##Start crond
/usr/sbin/crond start
/usr/bin/crontab -u apache /opt/crontab.conf
chown -R 100:101 /var/www/localhost/htdocs/
##Start httpd
/usr/sbin/httpd -D FOREGROUND
