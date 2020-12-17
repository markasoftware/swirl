[Service]
ExecStart=
ExecStart=/usr/bin/syncthing -no-browser -no-restart -gui-address=m4_getenv_req(WIREGUARD_IP):8384 -logflags=0
