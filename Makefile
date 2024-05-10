SHELL=/bin/bash
COMPOSE_FILE="./srcs/docker-compose.yml"
WP_VOLUME_PATH="/home/${USER}/data/wp"
DB_VOLUME_PATH="/home/${USER}/data/db"


all:
	@docker-compose -f $(COMPOSE_FILE) build
	@docker-compose -f $(COMPOSE_FILE) up -d

build:
	@docker-compose -f $(COMPOSE_FILE) build

start:
	@docker-compose -f $(COMPOSE_FILE) up -d

stop:
	@docker-compose -f $(COMPOSE_FILE) down

check:
	@docker-compose -f $(COMPOSE_FILE) ps

log:
	@docker-compose -f $(COMPOSE_FILE) logs

nginx:
	@docker exec -it nginx $(SHELL)

mariadb:
	@docker exec -it mariadb $(SHELL)

wordpress:
	@docker exec -it wordpress $(SHELL)

fclean:
	@docker-compose -f $(COMPOSE_FILE) down -v --rmi all --remove-orphans --timeout 0 || true
	@docker system prune -af || true
	@rm -rf $(WP_VOLUME_PATH)/* 
	@rm -rf $(DB_VOLUME_PATH)/*

reset: fclean run
