Clang Format
============

Install::

  sudo apt install \
    software-properties-common

Add the clang repository::

  sudo add-apt-repository "deb http://apt.llvm.org/bullseye/ llvm-toolchain-bullseye-14 main"
  sudo add-apt-repository "deb-src http://apt.llvm.org/bullseye/ llvm-toolchain-bullseye-14 main"
  sudo apt update

Installing the latest-and-greatest version on Debian Bullseye::

  sudo apt install clang-format-14
