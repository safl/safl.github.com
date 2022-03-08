Workstation Installation
========================

Grab the non-free installer image, it is just a lot easier to use since it
contains non-free drivers for network devices like your WiFi adapter.


Post-install
------------

...

Enable ``sudo``
---------------

Switch user to ``root``, update repositories, install ``sudo`` and add your
user to sudoers::

  # Switch user to 'root'
  su -
  apt -qy update
  apt -qy install \
    sudo \
    vim-gtk \
    git \
    git-gui \
    meld \
    htop
  usermod -aG sudo <username>

Log out and log back in for the group addition to take effect.

Update repositories and packages
--------------------------------

Make sure repositories and installation is up-to-date::

  sudo apt-get update && sudo apt-get upgrade && sudo apt-get dist-upgrade

Update Firmware
---------------

Update firmware::

  sudo apt-get install isenkram
  sudo isenkram-autoinstall-firmware

Then reboot for the firmware additons to take effect.

Toolbelt
--------

For the rest we need some basic tools::

  sudo apt-get install \
    build-essential \
    git \
    htop \
    python3-pip \
    shellcheck \
    stow \
    vim-gtk

  # Installing this with sudo via pip3 to get the latest version and install it
  # system-wide
  sudo pip3 install meson ninja
