qemu
====

Install::

  sudo apt-get install \
    qemu \
    qemu-utils \
    qemu-system-x86

Compiling from source
---------------------

Thenf or building qemu, install these::

  sudo apt-get install \
    libcap-ng-devel \
    libattr1-dev

Build like::

  mkdir -p build
  cd build
  ../configure \
  --audio-drv-list="" \
  --disable-docs \
  --disable-opengl \
  --disable-virglrenderer \
  --disable-vte \
  --disable-gtk \
  --disable-sdl \
  --disable-spice \
  --disable-vnc \
  --disable-curses \
  --disable-xen \
  --disable-smartcard \
  --disable-libnfs \
  --disable-libusb \
  --disable-glusterfs \
  --enable-virtfs \
  --enable-debug \
  --prefix=/opt/qemu \
  --target-list=x86_64-softmmu
  make -j$(nproc)

cloud-utils
-----------

Related to qemu are the cloud-init utilities::

  sudo apt-get install \
    cloud-utils
