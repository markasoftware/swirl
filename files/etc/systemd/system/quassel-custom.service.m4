[Unit]
Description=distributed IRC client using a central core component
Documentation=man:quasselcore(1)
Wants=network-online.target postgresql.service
After=network-online.target postgresql.service

[Service]
User=quassel-custom
Group=quassel-custom
WorkingDirectory=/home/quassel-custom
ExecStart=/usr/bin/quasselcore --configdir /home/quassel-custom --logfile /home/quassel-custom/quassel.log --loglevel INFO --port 4242 --listen m4_getenv_req(WIREGUARD_IP)
ExecReload=/bin/kill -HUP $MAINPID
Restart=on-failure

[Install]
WantedBy=multi-user.target
