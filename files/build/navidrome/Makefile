navidrome_dir := navidrome-$(NAVIDROME_VERSION)
navidrome_tar := navidrome-$(NAVIDROME_VERSION).tar.gz
navidrome_url := https://github.com/deluan/navidrome/releases/download/v$(NAVIDROME_VERSION)/navidrome_$(NAVIDROME_VERSION)_Linux_x86_64.tar.gz

/usr/local/bin/navidrome: $(navidrome_dir)/navidrome
	install $< $@

$(navidrome_dir)/navidrome: $(navidrome_tar)
	mkdir -p $(navidrome_dir)
	tar xaf $(navidrome_tar) -C $(navidrome_dir)
	touch $@ # modification time

$(navidrome_tar):
	curl -Lo $@ '$(navidrome_url)'
