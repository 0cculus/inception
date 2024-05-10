#!/bin/bash

SQLFILE=tmp.sql

if [ ! -d "/run/mysqld" ]; then
    mkdir -p /run/mysqld
    chown -R mysql:mysql /run/mysqld
    echo "Waiting on MariaDB daemon..."
fi

if [ ! -d "/var/lib/mysql/mysql" ]; then

	chown -R mysql:mysql /var/lib/mysql

	mysql_install_db --datadir=/var/lib/mysql --user=mysql --skip-test-db --rpm                             >> /dev/null

    echo "FLUSH PRIVILEGES;"                                                                                > SQLFILE
    echo "USE mysql;"                                                                                       >> SQLFILE
    echo "DELETE FROM mysql.user WHERE User='';"                                                            >> SQLFILE
    echo "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"      >> SQLFILE
    echo "ALTER USER 'root'@'localhost' IDENTIFIED BY 'noaccess';"                                          >> SQLFILE
    echo "CREATE DATABASE $DATABASE_NAME CHARACTER SET utf8;"                                               >> SQLFILE
    echo "CREATE USER '$DATABASE_ADMIN'@'%' IDENTIFIED by '$DATABASE_ADMIN_PW';"                            >> SQLFILE
    echo "GRANT ALL PRIVILEGES ON $DATABASE_NAME.* TO '$DATABASE_ADMIN'@'%';"                               >> SQLFILE
    echo "FLUSH PRIVILEGES;"                                                                                >> SQLFILE

    /usr/bin/mysqld --user=mysql --bootstrap < SQLFILE

    rm -rf SQLFILE
fi

echo "[mysqld]\n\
#skip-networking\n\
[galera]\n\
bind-address=0.0.0.0\n\
[embedded]\n\
[mariadb]\n\
[mariadb-10.5]" > /etc/my.cnf.d/mariadb-server.cnf

echo "MariaDB has started!"
exec mysqld_safe
