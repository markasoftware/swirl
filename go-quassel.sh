#!/bin/bash

source remotely.sh
remotely_go

remotely apt-get install -y rsync postgresql quassel-core libqt5sql5-psql
remotely systemctl stop quasselcore
remotely systemctl disable quasselcore

remotely id quassel-custom 2>/dev/null || remotely useradd -md /home/quassel-custom quassel-custom

# press x to hope
remotely su - postgres -c "psql -c \"CREATE USER \\\"quassel-custom\\\" WITH PASSWORD '$QUASSEL_POSTGRES_PASSWORD'\"" || true
remotely su - postgres -c 'createdb --owner quassel-custom quassel-custom' || true

upload /etc/systemd/system/quassel-custom.service
upload /etc/apparmor.d/disable -l # preserve symlinks
remotely apparmor_parser -R /etc/apparmor.d/usr.bin.quasselcore || true

remotely systemctl daemon-reload
remotely systemctl start postgresql
remotely systemctl enable postgresql
remotely systemctl start quassel-custom
remotely systemctl enable quassel-custom
remotely systemctl reload quassel-custom

echo
echo 'DONE with Quassel'
echo
