#!/bin/bash

source remotely.sh
remotely_go

# TODO: lock down shadowsocks more (prevent access to selfhosted services thru shadowsocks). Maybe
# run it as a certain user then use --uid-owner in iptables? or cgroups? Luckily everything is bound
# to the wireguard ip anyway.

remotely apt-get install -y rsync shadowsocks-libev

upload /etc/shadowsocks-libev/

remotely systemctl restart shadowsocks-libev
remotely systemctl enable shadowsocks-libev

echo
echo 'DONE with Shadowsocks'
echo
