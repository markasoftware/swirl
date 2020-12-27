#!/bin/bash

source remotely.sh
remotely_go

source go-networking.sh
source go-downloads.sh
# source go-netdata.sh
source go-web-server.sh
source go-quassel.sh
source go-shadowsocks.sh

echo
echo 'DONE with all!'
echo
