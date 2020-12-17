base_path    := /etc/letsencrypt/live
domain_certs := $(patsubst %,$(base_path)/%,$(LETSENCRYPT_DOMAINS))
domain_opts  := $(patsubst %,-d %,$(LETSENCRYPT_DOMAINS))

all: $(domain_certs)

$(base_path)/%:
	certbot certonly --non-interactive --agree-tos -m '$(LETSENCRYPT_EMAIL)' --standalone \
		-d $*
