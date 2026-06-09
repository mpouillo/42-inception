# ==============================================================
#							INCEPTION
# ==============================================================

all: up

up:
	@echo "Creating mariadb storage directories on host..."
	@mkdir -p /home/mpouillo/data/mariadb
	@mkdir -p /home/mpouillo/data/wordpress
	@echo "Building and starting containers..."
	@cd srcs && docker compose up -d --build

down:
	@cd srcs && docker compose down -v

secrets:
	cp -r ~/Documents/42/inception/secrets .
	cp ~/Documents/42/inception/srcs/.env srcs/.env

clean: down
	@echo "Cleaning up containers and networks..."
	@docker system prune -a -f

fclean: clean
	@echo "Removing volumes and host data records..."
	-@docker volume rm $$(docker volume ls -q) 2>/dev/null
	@sudo rm -rf /home/mpouillo/data

re: fclean all

.PHONY: all down clean fclean re
.DEFAULT_GOAL = all
