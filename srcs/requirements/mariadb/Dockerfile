FROM debian:bullseye

RUN apt update && apt upgrade -y

RUN apt install -y mariadb-server

EXPOSE 3306

COPY conf/config.sh /config.sh
RUN chmod +x /config.sh
ENTRYPOINT ["/config.sh"]
