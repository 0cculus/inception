FROM debian:bullseye

RUN apt update && apt upgrade -y

RUN apt install -y nginx openssl

RUN openssl req -x509 -nodes -days 90 -newkey rsa:4096 -out /etc/ssl/certs/server.crt -keyout /etc/ssl/private/server.key -subj "/C=CA/ST=QC/L=QC/O=42/OU=inception/CN=brheaume.42.fr" -sha256

RUN echo "root /var/www/html;\n\
server {\n\
    listen 443 ssl;\n\
    listen [::]:443 ssl;\n\
    server_name brheaume.42.fr;\n\
    ssl_protocols TLSv1.2 TLSv1.3;\n\
    ssl_certificate /etc/ssl/certs/server.crt;\n\
    ssl_certificate_key /etc/ssl/private/server.key;\n\
	root /var/www/html;\n\
    index index.php index.html;\n\
    location / {\n\
        autoindex on;\n\
        autoindex_format html;\n\
        try_files \$uri \$uri/ =404;\n\
    }\n\
    location /static {\n\
        try_files /static.html =404;\n\
    }\n\
    location ~ \.php$ {\n\
        include snippets/fastcgi-php.conf;\n\
        fastcgi_pass wordpress:9000;\n\
    }\n\
}" > etc/nginx/conf.d/default.conf

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
