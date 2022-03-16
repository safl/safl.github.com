#!/usr/bin/env bash
cd git
git clone https://github.com/Airblader/i3.git i3-gaps
cd i3-gaps
git checkout 4.20.1
meson setup builddir
meson compile -C builddir
sudo meson install -C builddir
