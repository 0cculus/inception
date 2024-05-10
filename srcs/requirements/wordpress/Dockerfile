FROM debian:bullseye

RUN apt update && apt upgrade -y
RUN apt install -y apt-utils
RUN apt install -y mariadb-client wget php7.4 php-mysqli php-fpm

RUN echo "[www]\n\
user = www-data\n\
group = www-data\n\
listen = 0.0.0.0:9000\n\
listen.owner = www-data\n\
listen.group = www-data\n\
pm = dynamic\n\
pm.max_children = 25\n\
pm.start_servers = 5\n\
pm.min_spare_servers = 1\n\
pm.max_spare_servers = 10" > /etc/php/7.4/fpm/pool.d/www.conf

COPY bonus/static.html /var/www/html/
RUN chmod 777 /var/www/html/static.html

COPY conf/config.sh /config.sh
CMD ["/config.sh"]
