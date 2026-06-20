.PHONY: install install-dev install-macos stow unstow update check

# Paquetes stow: todos los dirs top-level excepto `packages` (soporte).
# Agregar una app = crear un dir top-level. Se detecta automáticamente.
STOW_PKGS := $(filter-out packages,$(patsubst %/,%,$(wildcard */)))

install:
	./install.sh

install-dev:
	./install.sh --yes --variant dev

install-macos:
	./install.sh --yes --variant macos

stow:
	stow -v -t $(HOME) $(STOW_PKGS)

unstow:
	./install.sh --uninstall

update:
	git pull
	$(MAKE) stow

check:
	shellcheck install.sh
	shfmt -d install.sh
