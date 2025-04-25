#!/bin/bash

set -euo pipefail

# Init var
read -rp "Enter domain name (ex, yourdomain.com): " DOMAIN_NAME
read -rp "Enter email for Let's Encrypt (ex, email@myservermail.com): " CERTBOT_EMAIL
read -rp "Enter proxyfied address (ex, http://127.0.0.1:8080): " PROXY_PASS
NGINX_CONFIG="/etc/nginx/sites-available/$DOMAIN_NAME"

# Install nginx and certbot
sudo apt update && apt install -y nginx certbot python3-certbot-nginx

# Make config 80 for deploy cert
sudo tee "$NGINX_CONFIG" > /dev/null <<EOF
server {
    listen 80;
    server_name $DOMAIN_NAME;

    location / {
        root /var/www/html;
        index index.html index.htm;
    }
}
EOF

# Create symlink
sudo ln -sf "$NGINX_CONFIG" /etc/nginx/sites-enabled/
sudo systemctl restart nginx

# Deploy TLS certificate
sudo certbot --nginx -d $DOMAIN_NAME --agree-tos --email $CERTBOT_EMAIL --non-interactive

# Add config 443
sudo tee "$NGINX_CONFIG" > /dev/null <<EOF

server {
    listen 80;
    server_name $DOMAIN_NAME;

    return 301 https://\$host\$request_uri;
}

server {
    listen 443 ssl;
    server_name $DOMAIN_NAME;

    ssl_certificate /etc/letsencrypt/live/$DOMAIN_NAME/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/$DOMAIN_NAME/privkey.pem;
    include /etc/letsencrypt/options-ssl-nginx.conf;
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem;

    location / {
        proxy_pass $PROXY_PASS;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}

EOF

sudo systemctl reload nginx

# Autorenew certificates in CRON
echo "0 3 * * * certbot renew --quiet && systemctl reload nginx" | sudo tee -a /etc/crontab