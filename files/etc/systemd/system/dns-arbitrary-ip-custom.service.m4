[Unit]
Description=Arbitrary IP DNS resolver
After=network.target

[Install]
WantedBy=multi-user.target

[Service]
Type=simple
ExecStart=/usr/local/bin/dns-arbitrary-ip --base-domain m4_getenv_req(DNS_ARBITRARY_IP_BASE_DOMAIN)
MemoryMax=100M
MemorySwapMax=0
Restart=on-failure
