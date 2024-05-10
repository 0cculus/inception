#!/bin/sh

while ! mariadb -hmariadb -u$DATABASE_ADMIN -p$DATABASE_ADMIN_PW $DATABASE_NAME; do
    echo "[-] Waiting on MariaDB to start..."
    sleep 3
done

if [ ! -f "/var/www/html/wp-config.php" ]; then
	if [[ ${WP_ADMIN_USR,,} == *"admin"* ]]; then
		echo "--- Username should not contain admin ---"
		exit
	fi
	if [[ ${WP_ADMIN_PWD,,} == *${WP_ADMIN_USR,,}* ]]
		echo "--- Password should not contain username ---"
		exit
	fi
    
    wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp

    cd /var/www/html

    wp core download --allow-root
    wp config create --dbname="${DATABASE_NAME}" --dbuser="${DATABASE_ADMIN}" --dbpass="${DATABASE_ADMIN_PW}" --dbhost=mariadb --dbcharset="utf8" --allow-root
    wp core install --url="brheaume.42.fr" --title="${WP_TITLE}" --admin_user="${WP_ADMIN_USR}" --admin_password="${WP_ADMIN_PWD}" --admin_email="${WP_ADMIN_EMAIL}" --skip-email --allow-root
    wp user create "${WP_USER_USR}" "${WP_USER_EMAIL}" --role=author --user_pass="${WP_USER_PWD}" --allow-root
    wp theme install bizboost --activate --allow-root
fi

mkdir /run/php && chown www-data:www-data /run/php

echo "[+] Wordpress & PHP_FPM is Running !"
exec /usr/sbin/php-fpm7.4 --nodaemonize
