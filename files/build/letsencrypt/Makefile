base_path    := /etc/letsencrypt/live
domain_certs := $(patsubst %,$(base_path)%,$(LETSENCRYPT_DOMAINS))
domain_opts  := $(patsubst %,-d %,$(LETSENCRYPT_DOMAINS))

$(domain_certs):
	certbot --non-interactive --agree-tos -m '$(LETSENCRYPT_EMAIL)' \
		--webroot -w /var/certbot-webroot --renew-hook 'systemctl reload nginx' \
		$(domain_opts)
	systemctl reload nginx
