Clang Format
============

Pretty awesome code-format tool. Considering using ``astyle``? Don't, just use
``clang-format``.

Clang-Format 14 on Bullseye (easy)
----------------------------------

A script is provided::

  wget https://apt.llvm.org/llvm.sh
  chmod +x llvm.sh
  sudo ./llvm.sh 14

use that, or do the steps your-self like in the following section.

Clang-Format 14 on Debian Bullseye
----------------------------------

Install prerequisites::

  sudo apt -qy update
  sudo apt -qy install \
    wget \
    gnupg \
    software-properties-common

Add the clang repository::

  wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | sudo apt-key add -
  sudo add-apt-repository -y "deb http://apt.llvm.org/bullseye/ llvm-toolchain-bullseye-14 main"
  sudo add-apt-repository -y "deb-src http://apt.llvm.org/bullseye/ llvm-toolchain-bullseye-14 main"
  sudo apt -qy update

Installing the latest-and-greatest version on Debian Bullseye::

  sudo apt -qy install clang-format-14
