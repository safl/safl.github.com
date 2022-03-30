Alternatives
============

And how to update them, and change the preferred change the default.

Sometimes you just need a piece a software in the latest and greatest version.
When provided these are often affixed the version-name... bla bla... here is
the snippet for what you typically need.

Multiple ``clang-format``
-------------------------

Here is an example, for Debian Bullseye only ``clang-format`` version 13 is
provided. However, llvm provides recent version via their own package
repositires. Since this is a command-line tool, invoked via its name
``clang-format`` by default, then one can easily change to a different source
and redirect ``clang-format`` to the latest version installed::

  sudo update-alternatives --install /usr/bin/clang-format clang-format /usr/bin/clang-format-14 14
  sudo update-alternatives --install /usr/bin/clang-format clang-format /usr/bin/clang-format-13 13
  sudo update-alternatives --config gcc

You can inspect alternatives by running::

  update-alternatives --list clang-format

And switch between then using::

  sudo update-alternatives --config gcc

The number furtherst to the right is the "priority" of the alternative, by
using the version-number then newer versions are prioritzed higher.

Multiple ``gcc``
----------------

Sometimes a project doesn't work with default version provided. For example, I
has a build issue with the Linux kernel using ``gcc 10``. So, I attempted
builded the kernel using an older version of ``gcc`` by doing the following::

  sudo update-alternatives --config gcc
  sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-10 10
  sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-10 10
  sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-9 9
  sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-9 9
  sudo update-alternatives --config gcc

Note, this is not always fruitful, as other versions of the linker and standard
library might be the real root of the issue. However, for the issue I had where
a new default was introduced with gcc 10, which for the version of the Kernel I
had, was not yet addressed. Then it was a quick'n'dirty work-around.
