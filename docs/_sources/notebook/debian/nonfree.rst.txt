Proprietary Applications
------------------------

Althought ``.deb`` packages are available for a lot of non-free applications,
then they seem to always be a bit quirky, missing a dependency, errors when
updating, or dropping all sorts of weird stuff onto your system.

For the latter reason, then using things like :xref-flatpak:`FLATPAK<>`,
:xref-appimage:`AppImage<>`, and :xref-snapcraft:`SnapCraft<>` can be useful as
the user of those applications, as poorly-packaged non-free software will be
somewhat isolated/contained from an otherwise **clean** system.

Here we experiment with the FlatPaks::

  sudo apt-get install flatpak
  sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

Install Spotify, Discord, Zoom, Sublime Text and via flatpak::

  flatpak install flathub \
    com.discordapp.Discord \
    com.slack.Slack \
    com.spotify.Client \
    com.sublimetext.three \
    us.zoom.Zoom

The applications are integrated into the FreeBSD launcher, thus, they will pop
up in ``rofi`` and the XFCE4 Application Finder. Running them via CLI, then
prepend the name with the ``flatpak run`` for example::

  flatpak run com.spotify.Client

Which will start :xref-app-spotify:`Spotify<>`.

.. note::
   MS Teams is no longer available as a flatpak, it is instead a so-called
   Progressive-Web-App, whatever that entails, MS guarantees us that it is to
   provide a better product for Linux ahems. Ahem...