#!/bin/bash

if [ ! -d /run/php ]; then
	service php7.4-fpm start
	service php7.4-fpm stop
fi

if [[ ${WP_ADMIN_USR,,} == *"admin"* ]]; then
	echo "--- Username should not contain admin ---"
	exit
fi

if [[ ${WP_ADMIN_PWD,,} == *${WP_ADMIN_USR,,}* ]]; then
	echo "--- Password should not contain username ---"
	exit
fi

wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp

cd /var/www/html

if [[ ! -f /var/www/html/wp-config.php ]]; then
	wp core download --allow-root --path=/var/www/html
	wp config create --dbname="${DATABASE_NAME}" --dbuser="${DATABASE_USER}" --dbpass="${DATABASE_USER_PW}" --dbhost=mariadb:3306 --dbcharset="utf8" --allow-root
	wp core install --url="brheaume.42.fr" --title="${WP_TITLE}" --admin_user="${WP_ADMIN_USR}" --admin_password="${WP_ADMIN_PWD}" --admin_email="${WP_ADMIN_EMAIL}" --skip-email --allow-root
	wp user create "${WP_USER_USR}" "${WP_USER_EMAIL}" --role=author --user_pass="${WP_USER_PWD}" --allow-root
	wp theme install bizboost --activate --allow-root
fi

if [[ -f /var/www/html/wp-config.php ]]; then
	/usr/sbin/php-fpm7.4 -F
fi

echo "Wordpress has started!"
/usr/sbin/php-fpm7.4 -F
