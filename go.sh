#!/bin/bash

source remotely.sh
source vars.sh

# Navidrome and Transmission run under the downloads user

env_req NAVIDROME_VERSION
env_req TRANSMISSION_PASSWORD
env_req LETSENCRYPT_EMAIL

remotely apt-get install -y rsync curl make vim netdata nginx transmission-daemon wireguard \
	 shadowsocks-libev certbot
remotely apt-get install -y linux-headers-$(remotely uname -r) # remove when we get to a newer kernel
remotely apt-get install --no-install-recommends -y ffmpeg
remotely systemctl disable transmission-daemon
remotely systemctl stop transmission-daemon

remotely id downloads 2>/dev/null    || remotely useradd -md /home/downloads downloads
upload /home/downloads -og --chown downloads:downloads

upload /build
remotely make -C /build/navidrome "NAVIDROME_VERSION=$NAVIDROME_VERSION"

upload /etc/wireguard -p --chmod 600
upload /etc
# upload /etc/nginx/sites-enabled --delete

remotely systemctl daemon-reload
remotely systemctl enable nginx netdata transmission-daemon-custom navidrome-custom wg-quick@wg0 \
	 iptables-custom
remotely systemctl stop navidrome-custom shadowsocks-libev
remotely systemctl start nginx netdata transmission-daemon-custom navidrome-custom shadowsocks-libev \
	 wg-quick@wg0 iptables-custom
remotely systemctl reload nginx transmission-daemon-custom wg-quick@wg0

remotely make -C /build/letsencrypt "LETSENCRYPT_EMAIL=$LETSENCRYPT_EMAIL" \
	 'LETSENCRYPT_DOMAINS=swirl.markasoftware.com'

upload /
