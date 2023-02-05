MacOS
=====

Those Apple Silicon based Macs are pretty awesome, especially in terms of
power-efficiency and battery-life.

Brew
----

Apple provides an App store, however, it requires logging in with an
Apple-account. That is not really something I like... so instead I go with the
Brew package manager. In addition to providing packages, then it also have a
service-controller.

There are alternatives, such as macports, similar to the FreeBSD ports
collection. However, brew also contains non-free software, which is why I am
using MacOS to begin with: better support for non-free software.

The neat thing about brew is that everything I need can be installed using it,
with the exception of Rust, which should be installed via ``rustup``.

Install brew:

.. literalinclude:: 300_brew_install.cmd
   :language: bash

Setup ``PATH``::

  echo '# Set PATH, MANPATH, etc., for Homebrew.' >> /Users/$USER/.zprofile
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/$USER/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"

Install Packages:

.. literalinclude:: 400_brew_install_pkgs.cmd
   :language: bash

Install Casks:

.. literalinclude:: 500_brew_install_cask.cmd
   :language: bash

Rust
----

Install via untrusted sources:

.. literalinclude:: 200_rustup_install.cmd
   :language: bash

setting ``PATH``.

Python
------

A recent Python interpreter comes with macOS, thus no need to graba newer one
via Brew, thus, just setup you shell to expand ``PATH`` with the executables
provided via Python packages:

.. literalinclude:: 600_python_bin.cmd
   :language: bash

via pip
~~~~~~~

The PYthon Package Index (pypi) has a bunch tools implemented in Python, are reaidly installable via ``python3 -m pip instal ...``.

LunarVim
--------

macOS comes with vim, which is pretty great!

Window Manager
--------------

Using skhd and yabai::

  cp /opt/homebrew/opt/yabai/share/yabai/examples/yabairc ~/.yabairc
  cp /opt/homebrew/opt/yabai/share/yabai/examples/skhdrc ~/.skhdrc

Yabai is controlled via brew-services::

  brew services start yabai

yabai -- scripting additions
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Is this really needed? Stuff::

  shasum -a 256 $(which yabai)

  # input the line below into the file you are editing.
  #  replace <yabai> with the path to the yabai binary (output of: which yabai).
  #  replace <user> with your username (output of: whoami). 
  #  replace <hash> with the sha256 hash of the yabai binary (output of: shasum -a 256 $(which yabai)).
  #   this hash must be updated manually after running brew upgrade.

  safl ALL = (root) NOPASSWD: sha256:f1e7ca9556f7ba49f8a0be3e0b917dc0739da66b5760093a9a0f552798f5c92d /opt/homebrew/bin/yabai --load-sa

  sudo visudo -f /private/etc/sudoers.d/yabai

iTerm2
~~~~~~

* Appearance -> General -> Theme: Compact

* Profiles -> Colors -> Color Presets: Solarized Dark

* Profiles -> Colors -> Font: ??? 18

cdrtools
--------

Using cloud-init tools... images... recall which tool was used here.

macOS Settings
--------------

* Appearance

  * Appearance: Dark
  * Sidebar icon size: Large

* Desktop & Dock

  * Position on Screen: Left

Remove icons from taskbar

* Keyboard
  * Modifier Keys -> Caps Lock key: Control

* Trackpad
  * Scroll & Zoom -> Natural scrolling: off

macOS Tweaks
------------

...

Home/End
~~~~~~~~

Create the file ``~/Library/KeyBindings/DefaultKeyBinding.dict``, with the content:

.. literalinclude:: DefaultKeyBinding.dict
   :language: bash

Very nice... I just much prefer the way this works... being able to use
Home/End, and selecting text.

