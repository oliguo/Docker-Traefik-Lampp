#!/bin/sh
echo extension=pdo_sqlsrv.so >> `php --ini | grep "Scan for additional .ini files" | sed -e "s|.*:\s*||"`/10_pdo_sqlsrv.ini
echo extension=sqlsrv.so >> `php --ini | grep "Scan for additional .ini files" | sed -e "s|.*:\s*||"`/20_sqlsrv.ini

umask 0000
##Start crond
/usr/sbin/crond start
/usr/bin/crontab /opt/crontab.conf

##Start httpd
/usr/sbin/httpd -D FOREGROUND
