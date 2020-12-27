#!/bin/bash

source remotely.sh
remotely_go

remotely apt-get install -y rsync netdata

upload /etc/netdata

remotely systemctl daemon-reload
remotely systemctl restart netdata
remotely systemctl enable netdata

echo
echo 'DONE with Netdata'
echo
