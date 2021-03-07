#!/bin/sh
umask 0000
##Start crond
/usr/sbin/crond start
/usr/bin/crontab /opt/crontab.conf

##Start httpd
/usr/sbin/httpd -D FOREGROUND
