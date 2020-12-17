#!/bin/bash

remotely apt-get install -y rsync netdata

upload /etc/netdata

remotely systemctl daemon-reload
remotely systemctl restart netdata
remotely systemctl enable netdata
