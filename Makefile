.PHONY: install install-dev install-macos stow unstow update check

install:
	./install.sh

install-dev:
	./install.sh --yes --variant dev

install-macos:
	./install.sh --yes --variant macos

stow:
	stow -v -t $(HOME) --no-folding .config
	ln -snf $(PWD)/.config/starship.toml $(HOME)/.config/starship.toml
	ln -snf $(PWD)/home/.zshrc $(HOME)/.zshrc

unstow:
	./install.sh --uninstall

update:
	git pull
	$(MAKE) stow

check:
	shellcheck install.sh
	shfmt -d install.sh
