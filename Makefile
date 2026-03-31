dev:
	docker compose up --build

down:
	docker compose down

cert:
	DOMAIN=viljarb.online GITEA_DOMAIN=gitea.viljarb.online GITEA_ROOT_URL=https://gitea.viljarb.online/ EMAIL=viljarb@tutanota.com docker compose -f compose.certbot.yml --profile certbot run --rm certbot

prod:
	DOMAIN=viljarb.online GITEA_DOMAIN=gitea.viljarb.online GITEA_ROOT_URL=https://gitea.viljarb.online/ EMAIL=viljarb@tutanota.com docker compose up --build
