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
		gimp \
		git \
		git-gui \
		gparted \
		helix \
		htop \
		keychain \
		libxcb-devel \
		light \
		lm_sensors \
		meld \
		meson \
		pipx \
		pre-commit \
		pylsp \
		python3-build \
		python3-jinja2 \
		qemu-kvm \
		qemu-system-x86 \
		rsync \
		screen \
		slurp \
		stow \
		s-tui \
		thunderbird \
		virt-manager \
		virt-viewer \
		wdisplays \
		wl-clipboard \
		wlogout

These packages are for building qemu from source::

	sudo dnf install \
		glib2-devel \

Keychain
========

Enable the keychain::

	systemctl --user status ssh-agent
	systemctl --user start ssh-agent
	systemctl --user enable ssh-agent

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

Rust-lang
=========

Install rust-lang via rustup (https://rustup.rs/)::

	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

Install via ``cargo``:

	cargo install jless

Google Chrome
=============

Install Google-Chrome

	sudo dnf install fedora-workstation-repositories
	sudo dnf config-manager setopt google-chrome.enabled=1
	sudo dnf install google-chrome-stable

FlatHub
=======

Add Flathub to Flatpak repository::

	flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

Discord (via flatpak)
~~~~~~~~~~~~~~~~~~~~~

Do this::

	flatpak install discord
	flatpak override --user --socket=wayland com.discordapp.Discord	

For those pesky MS Exchange endpoints via Thunderbird or webmail::

	sudo update-crypto-policies --set LEGACY

Config Changes::

	sudo usermod -aG libvirt $USER