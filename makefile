DOCKER_COMPOSE=docker-compose

up:
	$(DOCKER_COMPOSE) up -d --build

build:
	$(DOCKER_COMPOSE) build

down:
	$(DOCKER_COMPOSE) down

restart:
	$(DOCKER_COMPOSE) restart

logs:
	$(DOCKER_COMPOSE) logs -f

add-hosts:
	@echo "Adding hosts entries (requires sudo)"
	@printf "127.0.0.1 pacmusic.test\n127.0.0.1 stg.pacmusic.test\n" | sudo tee -a /etc/hosts

rm-hosts:
	@echo "Removing pacmusic.test entries from /etc/hosts (requires sudo)"
	@sudo sed -i '' '/pacmusic.test/d' /etc/hosts || true

cert-local:
	@echo "Generating mkcert certificate"
	@mkdir -p ./nginx/ssl/live/pacmusic.test
	@mkcert -cert-file ./nginx/ssl/live/pacmusic.test/fullchain.pem -key-file ./nginx/ssl/live/pacmusic.test/privkey.pem pacmusic.test stg.pacmusic.test localhost 127.0.0.1 ::1

nginx-test:
	@docker exec pacmusic-nginx nginx -t || true

test:
	@echo "curl https://pacmusic.test and https://stg.pacmusic.test (insecure ok for testing)"
	@curl -I --insecure https://pacmusic.test || true
	@curl -I --insecure https://stg.pacmusic.test || true

clean:
	@docker compose down --rmi local -v --remove-orphans
	@echo "Stopped containers and removed local images/volumes"
