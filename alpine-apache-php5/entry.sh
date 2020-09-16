#!/bin/sh

##Start crond
/usr/sbin/crond start
/usr/bin/crontab /opt/crontab.conf

##Start httpd
/usr/sbin/httpd -D FOREGROUND