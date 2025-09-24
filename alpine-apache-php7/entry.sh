#!/bin/sh
echo extension=pdo_sqlsrv.so >> `php --ini | grep "Scan for additional .ini files" | sed -e "s|.*:\s*||"`/10_pdo_sqlsrv.ini
echo extension=sqlsrv.so >> `php --ini | grep "Scan for additional .ini files" | sed -e "s|.*:\s*||"`/20_sqlsrv.ini

umask 0022
##Start crond
/usr/sbin/crond start
/usr/bin/crontab -u apache /opt/crontab.conf
chown -R :apache /var/www/localhost/htdocs/
chmod -R 770 /var/www/localhost/htdocs/
##Start httpd
/usr/sbin/httpd -D FOREGROUND
