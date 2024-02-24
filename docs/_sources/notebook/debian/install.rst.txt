Workstation Installation
========================

Grab the latest offical Debian installer image. Note that, starting with
``bookworm`` then non-free is included, thus the official installer image is
great. Put this on installation media. I really enjoy using Ventoy for this.

Post install I do the following, regardless of the whether the system is a SBC,
a laptop, or a workstation.

Enable ``sudo``
---------------

Switch user to ``root``, update repositories, install ``sudo`` and add your
user to sudoers:

.. code-block:: bash

  # Switch user to 'root'
  su -
  apt-get -qy update
  apt-get -qy install sudo
  usermod -aG sudo <username>

Log out and log back in for the group addition to take effect.

Increase console text size
---------------------------

.. code-block:: bash

  sudo dpkg-reconfigure console-setup


Set timezone
------------

See the timezones with:

.. code-block:: bash

  sudo timedatectl list-timezones


Then switch to it by using one of the following, this is usually convenient as a
post-install step as well, e.g. when traveling:


.. code-block:: bash

  # Denmark
  sudo timedatectl set-timezone Europe/Copenhagen

.. code-block:: bash

  # Korea / Seoul
  sudo timedatectl set-timezone Asia/Seoul

.. code-block:: bash

  # US West-coast
  sudo timedatectl set-timezone US/Pacific


Update repositories and packages
--------------------------------

Make sure repositories and installation is up-to-date:

.. code-block:: bash

  sudo apt-get update && sudo apt-get upgrade && sudo apt-get dist-upgrade

Update Firmware
---------------

Update firmware:

.. code-block:: bash

  sudo apt-get install isenkram
  sudo isenkram-autoinstall-firmware

Then reboot for the firmware additons to take effect.

Toolbelt
--------

For the rest we need some basic tools:

.. code-block:: bash

  sudo apt-get install \
    btop \
    build-essential \
    clang \
    clangd \
    curl \
    gdb \
    git \
    htop \
    meld \
    meson \
    pahole \
    parallel \
    pipx \
    rsync \
    screen \
    stow \
    valgrind \
    vim

Setup ``pipx```:

.. code-block:: bash

  pipx ensurepath
  pipx completions

Install and setup the toolchain for the Rust language:

.. code-block:: bash

  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh 
