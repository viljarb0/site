#!/usr/bin/env sh
set -e

if [ -n "$DOMAIN" ] && [ -n "$EMAIL" ]; then
    # for production: get Let's Encrypt cert
    if [ ! -f "/etc/letsencrypt/live/$DOMAIN/fullchain.pem" ]; then
        certbot certonly --standalone \
            -d "$DOMAIN" \
            --email "$EMAIL" \
            --agree-tos \
            --non-interactive
    fi
    export SSL_CERTIFICATE="/etc/letsencrypt/live/$DOMAIN/fullchain.pem"
    export SSL_CERTIFICATE_KEY="/etc/letsencrypt/live/$DOMAIN/privkey.pem"
else
    # for development: self-signed cert
    echo "Development mode: using self-signed certificate"
    mkdir -p /etc/nginx/certs
    if [ ! -f /etc/nginx/certs/cert.pem ]; then
        openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
            -keyout /etc/nginx/certs/key.pem \
            -out /etc/nginx/certs/cert.pem \
            -subj "/CN=localhost"
    fi
    export DOMAIN="localhost"
    export SSL_CERTIFICATE="/etc/nginx/certs/cert.pem"
    export SSL_CERTIFICATE_KEY="/etc/nginx/certs/key.pem"
fi

# generate nginx config from template
envsubst '${DOMAIN} ${SSL_CERTIFICATE} ${SSL_CERTIFICATE_KEY}' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf

# generate gitea config when GITEA_DOMAIN is set
mkdir -p /etc/nginx/conf.d
if [ -n "$GITEA_DOMAIN" ]; then
    envsubst '${GITEA_DOMAIN} ${SSL_CERTIFICATE} ${SSL_CERTIFICATE_KEY}' < /etc/nginx/nginx-gitea.conf.template > /etc/nginx/conf.d/gitea.conf
else
    echo "# Gitea not configured" > /etc/nginx/conf.d/gitea.conf
fi

exec nginx -g "daemon off;"
