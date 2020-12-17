# Swirl wg0.conf

[Interface]
Address = m4_getenv_req(WIREGUARD_IP_BLOCK)
ListenPort = 51820
PrivateKey = m4_getenv_req(WIREGUARD_PRIVKEY)

[Peer]
# Nathan's Server
PublicKey = m4_getenv_req(WIREGUARD_NATHAN_PUBKEY)
AllowedIPs = m4_getenv_req(WIREGUARD_NATHAN_IP)

[Peer]
# Mark's Desktop
PublicKey = m4_getenv_req(WIREGUARD_HOME_PUBKEY)
AllowedIPs = m4_getenv_req(WIREGUARD_HOME_IP)

[Peer]
# Mark's Laptop
PublicKey = m4_getenv_req(WIREGUARD_AWAY_PUBKEY)
AllowedIPs = m4_getenv_req(WIREGUARD_AWAY_IP)

[Peer]
# Mark's Phone
PublicKey = m4_getenv_req(WIREGUARD_PHONE_PUBKEY)
AllowedIPs = m4_getenv_req(WIREGUARD_PHONE_IP)
