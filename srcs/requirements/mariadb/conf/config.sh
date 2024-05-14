#!/bin/bash

SQLFILE=tmp.sql

if [ ! -d "/run/mysqld" ]; then
	mkdir -p /run/mysqld
	chown -R mysql:mysql /run/mysqld
	echo "Waiting on MariaDB daemon..."
fi

chown -R mysql:mysql /var/lib/mysql

mysql_install_db --datadir=/var/lib/mysql --user=mysql --skip-test >> /dev/null

echo "FLUSH PRIVILEGES;" >> SQLFILE
echo "CREATE DATABASE IF NOT EXISTS \`${DATABASE_NAME}\`;" >> SQLFILE
echo "CREATE USER IF NOT EXISTS \`${DATABASE_USER}\`@'%' IDENTIFIED BY '${DATABASE_USER_PW}';" >> SQLFILE
echo "GRANT ALL PRIVILEGES ON \`${DATABASE_NAME}\`.* TO \`${DATABASE_USER}\`@'%';" >> SQLFILE
echo "ALTER USER \`root\`@\`localhost\` IDENTIFIED BY '${DATABASE_ADMIN_PW}';" >> SQLFILE
echo "GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' WITH GRANT OPTION;" >> SQLFILE
echo "FLUSH PRIVILEGES;" >> SQLFILE

mysqld --user=mysql --bootstrap --silent < SQLFILE

rm -rf SQLFILE

echo "[mysqld]\n\
datadir=/var/lib/mysql\n\
socket=/var/run/mysql/mysqld.sock\n\
bind-address=*\n\
port=3306\n\
user=mysql" > /etc/mysql/mariadb.conf.d/50-server.cnf
chmod 600 /etc/mysql/mariadb.conf.d/50-server.cnf

echo "MariaDB has started!"
exec mysqld_safe
