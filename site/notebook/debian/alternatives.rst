Alternatives
============

And how to update them, and change the preferred change the default.

Sometimes you just need a piece a software in the latest and greatest version. When provided these
are often affixed the version-name... bla bla... here is the snippet for what you typically need::

Here is an example, for Debian Bullseye only ``clang-format`` version is provided. However, llvm
provides recent version via their own package repositires. Since this is a command-line tool,
invoked via its name ``clang-format`` by default, then one can easily change to a different source
and redirect ``clang-format`` to the latest version installed::

        sudo update-alternatives --install /usr/bin/clang-format clang-format /usr/bin/clang-format-14 100
        sudo update-alternatives --install /usr/bin/clang-format clang-format /usr/bin/clang-format-13 90
        update-alternatives --list clang-format
