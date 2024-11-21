Fedora as Desktop
=================

Using the Fedora sway spin, installing this::

	sudo dnf install \
		asciinema \
		btop \
		clangd \
		clang-tools-extra \
		cloud-utils \
		dmidecode \
		doxygen \
		flatpak \
		git \
		gparted \
		helix \
		htop \
		keychain \
		light \
		meld \
		pipx \
		python3-jinja2 \
		qemu-kvm \
		qemu-system-x86 \
		rsync \
		screen \
		slurp \
		stow \
		s-tui \
		lm_sensors \
		thunderbird \
		virt-manager \
		virt-viewer \
		wdisplays \
		wl-clipboard \
		wlogout \

Install Google-Chrome::

	sudo dnf install fedora-workstation-repositories
	sudo dnf config-manager setopt google-chrome.enabled=1
	sudo dnf install google-chrome-stable

Add Flathub to Flatpak repository::

	flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

Install Discord (via flatpak)::

	flatpak install discord
	flatpak override --user --socket=wayland com.discordapp.Discord	

Install rust-lang via rustup (https://rustup.rs/)::

	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

Install via ``cargo``:

	cargo install jless

For those pesky MS Exchange endpoints via Thunderbird or webmail::

	sudo update-crypto-policies --set LEGACY

Config Changes::

	sudo usermod -aG libvirt $USER

Docker
======

Remove stuff::

	sudo dnf remove docker \
		docker-client \
		docker-client-latest \
		docker-common \
		docker-latest \
		docker-latest-logrotate \
		docker-logrotate \
		docker-selinux \
		docker-engine-selinux \
		docker-engine

Setup repos::

	sudo dnf -y install dnf-plugins-core
	sudo dnf-3 config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo

Install Docker::

	sudo dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

Then add yourself to the docker-group::

	sudo usermod -aG docker $USER

Start Docker::

	sudo systemctl enable --now docker

Keychain
========

Enable the keychain::

	systemctl --user status ssh-agent
	systemctl --user start ssh-agent
	systemctl --user enable ssh-agent