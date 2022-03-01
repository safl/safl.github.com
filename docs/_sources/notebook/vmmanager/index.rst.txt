VM-Manager
==========

For the purpose of spinning up self-hosted runners for GitHUB Actions, then
here is one approach to slice up some bare metal as virtual machines each
instance to run a self-hosted runner.

Install Debian Bullseye
-----------------------

Fill the entire disk, create a user and install the Open-SSH server.

Enable ``sudo``
~~~~~~~~~~~~~~~

Switch user to ``root``, update repositories, install ``sudo`` and add your
user to sudoers::

  # Switch user to 'root'
  su -
  apt-get update && apt-get install sudo
  usermod -aG sudo <username>

Log out and log back in for the group addition to take effect.

Update repositories and packages
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Make sure repositories and installation is up-to-date::

  sudo apt-get update && sudo apt-get upgrade && sudo apt-get dist-upgrade

Update Firmware
~~~~~~~~~~~~~~~

Update firmware::

  sudo apt-get install isenkram
  sudo isenkram-autoinstall-firmware

Then reboot for the firmware additons to take effect.

Install Prerequisites
---------------------

Install qemu, libvirt and vm-manager::

  sudo apt install \
    qemu \
    qemu-utils \
    qemu-system \
    libvirt-daemon-system \
    cloud-utils \
    time \
    python3 \
    python3-pip

This should install qemu, enable KVM, and provide tools management.

Add your user to the `libvirt` group::

  sudo adduser $USER libvirt

cijoe-pkg-qemu
--------------

...

VM-Manager
----------

Install::

  sudo apt install virt-manager

...

Images
------

...


