#!/usr/bin/env sh
set -e

if [ -z "$DOMAIN" ] || [ -z "$EMAIL" ]; then
    echo "Skipping certificate (development mode)"
    exit 0
fi

# Build domain list for cert (DOMAIN + optional GITEA_DOMAIN)
DOMAINS="-d $DOMAIN"
if [ -n "$GITEA_DOMAIN" ]; then
    DOMAINS="$DOMAINS -d $GITEA_DOMAIN"
fi

# get/renew cert
certbot certonly --standalone \
    $DOMAINS \
    --email "$EMAIL" \
    --agree-tos \
    --non-interactive \
    --keep-until-expiring
