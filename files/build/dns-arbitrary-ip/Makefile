dns_arbitrary_ip_path := dns-arbitrary-ip-$(DNS_ARBITRARY_IP_GIT_SHA)
dns_arbitrary_ip_url := https://raw.githubusercontent.com/markasoftware/dns-arbitrary-ip/$(DNS_ARBITRARY_IP_GIT_SHA)/dns_arbitrary_ip.py

/usr/local/bin/dns-arbitrary-ip: $(dns_arbitrary_ip_path)
	install $< $@

$(dns_arbitrary_ip_path):
	curl -Lo $@ '$(dns_arbitrary_ip_url)'
