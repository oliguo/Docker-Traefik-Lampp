#!/bin/sh
umask 0022
##Start crond
/usr/sbin/crond start
/usr/bin/crontab -u apache /opt/crontab.conf
chown -R :apache /var/www/localhost/htdocs/
chmod -R 770 /var/www/localhost/htdocs/
##Start httpd
/usr/sbin/httpd -D FOREGROUND
