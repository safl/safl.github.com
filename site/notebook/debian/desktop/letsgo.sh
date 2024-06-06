#!/usr/bin/env bash

if [ "$(tty)" != "/dev/tty1" ]; then
  echo "Invalid tty($tty)"
  exit 0
fi

export CLUTTER_BACKEND=wayland
export ECORE_EVAS_ENGINE=wayland-egl
export ELM_ENGINE=wayland_egl
export GDK_BACKEND=wayland
export _JAVA_AWT_WM_NONREPARENTING=1
export MOZ_ENABLE_WAYLAND=1
export MOZ_WEBRENDER=1
export NO_AT_BRIDGE=1
export QT_QPA_PLATFORM=wayland-egl
export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
export QT_WAYLAND_FORCE_DPI=physical
export SDL_VIDEODRIVER=wayland
export XDG_CURRENT_DESKTOP=sway
export XDG_RUNTIME_DIR=/tmp
export XDG_SESSION_DESKTOP=sway
export XDG_SESSION_TYPE=wayland
export PYTHON_KEYRING_BACKEND=keyring.backends.null.Keyring

eval $(keychain --eval --dir $HOME/.config/keychain --quiet --noask --agents gpg,ssh id_rsa)
exec sway
