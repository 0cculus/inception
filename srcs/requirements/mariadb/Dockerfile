FROM debian:bullseye

RUN apt update && apt upgrade -y

RUN apt install -y mariadb-server

COPY conf/config.sh /config.sh
ENTRYPOINT ["/config.sh"]
