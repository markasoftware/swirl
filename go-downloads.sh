#!/bin/bash

env_req NAVIDROME_VERSION
env_req TRANSMISSION_PASSWORD

remotely apt-get install -y rsync make transmission-daemon
remotely apt-get install -y --no-install-recommends ffmpeg

remotely id downloads 2>/dev/null || remotely useradd -md /home/downloads downloads
upload /home/downloads -og --chown downloads:downloads

upload /build/navidrome
remotely make -C /build/navidrome "NAVIDROME_VERSION=$NAVIDROME_VERSION"

upload /etc/navidrome.toml
upload /etc/systemd/system/navidrome-custom.service
upload /etc/systemd/system/transmission-daemon-custom.service

remotely systemctl daemon-reload
remotely systemctl start transmission-daemon-custom
# navidrome has no reload
remotely systemctl reload transmission-daemon-custom || true
remotely systemctl restart navidrome-custom
remotely systemctl enable transmission-daemon-custom navidrome-custom
