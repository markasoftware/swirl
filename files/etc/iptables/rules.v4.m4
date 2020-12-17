*filter
:INPUT DROP [0:0]
:FORWARD DROP [0:0]
:OUTPUT ACCEPT [0:0]

-A INPUT -p tcp --dport 22 -j ACCEPT
-A INPUT -p tcp --dport 80 -j ACCEPT
-A INPUT -p udp --dport 80 -j ACCEPT
-A INPUT -p tcp --dport 443 -j ACCEPT
-A INPUT -p udp --dport 443 -j ACCEPT
-A INPUT -p tcp --dport 8388 -j ACCEPT 
-A INPUT -p udp --dport 8388 -j ACCEPT
-A INPUT -p tcp --dport 22000 -j ACCEPT
-A INPUT -p tcp --dport 51413 -j ACCEPT
-A INPUT -p udp --dport 51413 -j ACCEPT
-A INPUT -p udp --dport 51820 -j ACCEPT

-A INPUT -p icmp --icmp-type 3 -j ACCEPT
-A INPUT -p icmp --icmp-type 4 -j ACCEPT
-A INPUT -p icmp --icmp-type 8 -j ACCEPT
-A INPUT -p icmp --icmp-type 11 -j ACCEPT

-A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

-A INPUT -i lo -j ACCEPT

-A INPUT --source m4_getenv_req(WIREGUARD_NATHAN_IP) -j DROP
-A INPUT --source m4_getenv_req(WIREGUARD_IP_BLOCK) -j ACCEPT

-A FORWARD --source m4_getenv_req(WIREGUARD_IP_BLOCK) -j ACCEPT
-A FORWARD -m conntrack --ctorigsrc m4_getenv_req(WIREGUARD_IP_BLOCK) -j ACCEPT
-A FORWARD --destination m4_getenv_req(WIREGUARD_NATHAN_IP) -p tcp --dport 25565 -j ACCEPT
-A FORWARD --destination m4_getenv_req(WIREGUARD_NATHAN_IP) -p tcp --dport 6900:6999 -j ACCEPT

COMMIT

*nat
:PREROUTING ACCEPT [0:0]
:INPUT ACCEPT [0:0]
:POSTROUTING ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]

-A PREROUTING -p tcp --dport 25565 -j DNAT --to-destination m4_getenv_req(WIREGUARD_NATHAN_IP)
-A PREROUTING -p tcp --dport 6900:6999 -j DNAT --to-destination m4_getenv_req(WIREGUARD_NATHAN_IP)

-A POSTROUTING --source m4_getenv_req(WIREGUARD_IP_BLOCK) ! -d m4_getenv_req(WIREGUARD_IP_BLOCK) -j MASQUERADE
-A POSTROUTING --destination m4_getenv_req(WIREGUARD_NATHAN_IP) -p tcp --dport 25565 -j MASQUERADE
-A POSTROUTING --destination m4_getenv_req(WIREGUARD_NATHAN_IP) -p tcp --dport 6900:6999 -j MASQUERADE

COMMIT
