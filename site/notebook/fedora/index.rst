Fedora as Desktop
=================

Using the Fedora sway spin, installing this::

	sudo dnf install \
		alacritty \
		clang-tools-extra \
		doxygen \
		gparted \
		grim \
		helix \
		htop \
		keychain \
		meld \
		pipx \
		python3-jinja2 \
		rsync \
		screen \
		slurp \
		stow \
		swaybg \
		swayidle \
		swaylock \
		thunderbird \
		vim \
		virt-manager
		wdisplays \
		wl-clipboard \
		wlogout \
		wofi

For those pesky MS Exchange endpoints via Thunderbird or webmail::

	sudo update-crypto-policies --set LEGACY
