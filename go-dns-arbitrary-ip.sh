#!/bin/bash

source remotely.sh
remotely_go

env_req DNS_ARBITRARY_IP_GIT_SHA

remotely apt-get install -y rsync python3

upload /build/dns-arbitrary-ip
remotely make -C /build/dns-arbitrary-ip "DNS_ARBITRARY_IP_GIT_SHA=$DNS_ARBITRARY_IP_GIT_SHA"

upload /etc/systemd/system/dns-arbitrary-ip-custom.service

remotely systemctl daemon-reload
remotely systemctl stop dns-arbitrary-ip-custom
remotely systemctl enable --now dns-arbitrary-ip-custom
