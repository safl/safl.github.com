From XFCE + i3 to sway & co
===========================

So, sway is just the compositor and manager, so a lot of stuff is missing in
terms of complete desktop experience provided by XFCE. Here is what I have come
up with so far::

	sudo apt-get install \
		alacritty \
		grim \
		keychain \
		libwayland-egl-backend-dev \
		lightdm-gtk-greeter-settings \
		pasystray \
		seatd \
		slurp \
		sway \
		sway-backgrounds \
		swaybg \
		swayidle \
		swaylock \
		waybar \
		wdisplays \
		wl-clipboard \
		wlogout \
		wofi \
		xdg-desktop-portal-wlr \
		xwayland

Unfortunately, then a lot of applications are running incredibly slow. Such
as firefox, thunderbird, and for some reason then launching the waybar takes
forever.

Then launch it with a script ``letsgo.sh``:

.. literalinclude:: letsgo.sh
   :language: bash

.