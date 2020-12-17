#!/bin/bash

remotely apt-get install -y rsync syncthing

remotely id syncboi 2>/dev/null || remotely useradd -md /home/syncboi syncboi

upload /etc/systemd/system/syncthing@.service.d
remotely systemctl daemon-reload
remotely systemctl restart syncthing@syncboi
remotely systemctl enable syncthing@syncboi

# that was easy!
