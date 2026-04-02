dev:
	docker compose up --build

down:
	docker compose down

up:
	DOMAIN=viljarb.online GITEA_DOMAIN=gitea.viljarb.online GITEA_ROOT_URL=https://gitea.viljarb.online/ EMAIL=viljarb@tutanota.com docker compose -f compose.certbot.yml --profile certbot run --rm certbot
	DOMAIN=viljarb.online GITEA_DOMAIN=gitea.viljarb.online GITEA_ROOT_URL=https://gitea.viljarb.online/ EMAIL=viljarb@tutanota.com docker compose up --build -d
