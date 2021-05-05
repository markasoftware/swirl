#!/bin/bash

source remotely.sh
remotely_go

env_req LETSENCRYPT_EMAIL

remotely apt-get install -y rsync nginx certbot
remotely systemctl daemon-reload

remotely id public-html 2>/dev/null || remotely useradd -md /home/public-html public-html

upload /etc/nginx
# is -L on by default?
upload /etc/nginx/sites-enabled -L --delete

upload /build/letsencrypt
upload /etc/letsencrypt/renewal-hooks
remotely systemctl stop nginx
remotely make -C /build/letsencrypt "LETSENCRYPT_EMAIL=$LETSENCRYPT_EMAIL" \
	 'LETSENCRYPT_DOMAINS=swirl.markasoftware.com markasoftware.com www.markasoftware.com'

remotely systemctl start nginx
remotely systemctl enable nginx

echo
echo 'DONE with Web Server'
echo
