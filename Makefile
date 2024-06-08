DOCKER_COMPOSE:= docker-compose -f ./srcs/docker-compose.yml

all: up

up:
	@if [ ! -d /home/$(USER)/data/mariadb-volume ] || [ ! -d /home/$(USER)/data/wordpress-volume ]; then \
		mkdir -p /home/$(USER)/data/mariadb-volume /home/$(USER)/data/wordpress-volume; \
	fi
	$(DOCKER_COMPOSE) up --build --detach

down:
	$(DOCKER_COMPOSE) down

clean:
	$(DOCKER_COMPOSE) down --rmi all --volumes

nuke:
	docker system prune -a

fclean: clean nuke

re: fclean up

.PHONY: all up down re nuke clean fclean
