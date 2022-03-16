Custom Kernel
-------------

These are instructions for building a custom Linux Kernel as a Debian package
on the system where it will be installed.

* The kernel will be built using the current Kernel configuration with minimal
  custom changes, you can add more.
* The kernel will be built as an installable Debian Package, this is
  conventient as it can easily be uninstalled again.
* The kernel is built from sources available in the folder ``$HOME/git/linux``.

Install pre-reqs:

.. literalinclude:: install.sh
   :language: bash
   :lines: 1-

Grab the kernel sources and then do::

  make olddefconfig

Edit the ``.config`` making sure that the following is set::

  CONFIG_SYSTEM_TRUSTED_KEYS=""

And unless you need it, then disable debug info, with the option::

  CONFIG_DEBUG_INFO=n

Define the environment variable ``LOCALVERSION``, this will embed the string in
the kernel-version, making it easy to identify your customized Kernel::

  export LOCALVERSION="foo42"

Then go ahead and build::

  /usr/bin/time make -j`nproc` bindeb-pkg

The Debian packages are emitted in the parent directory, this can get messy.
So, go ahead and put the packages somewhere else, e.g.::

  rm -r "${HOME}/packages/${LOCALVERSION}"
  mkdir -p "${HOME}/packages/${LOCALVERSION}"
  mv ../{*.deb,*.buildinfo,*.changes} "$HOME/packages/${LOCALVERSION}"

Go ahead and install it by invoking::

  sudo dpkg -i "$HOME/packages/${LOCALVERSION}/*.deb"

You organize the packages as you see fit, but something like the above is not a
bad idea.

