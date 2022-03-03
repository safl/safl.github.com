FreeBSD
=======

Installation
------------

...

First-boot
----------

Login as ``root`` and run::

  # Update the kernel and userland
  freebsd-update fetch
  freebsd-update install

  # Refresh the third-party binary package registry
  pkg update
  pkg upgrade

  # Install a couple of utilities
  pkg install \
    vim \
    git \
    bash \
    bash-completion \
    htop \
    sudo

  echo "odus    ALL=(ALL) ALL" >> /usr/local/etc/sudoers.d/odus

Then log out and log in with ``odus``
