[global]
	run as user = netdata
	# not sure what these do
	web files owner = root
	web files group = root
	bind socket to IP = m4_getenv_req(WIREGUARD_IP)
