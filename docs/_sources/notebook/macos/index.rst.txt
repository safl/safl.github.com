MacOS
=====

Those Apple Silicon based Macs are pretty awesome, especially in terms of
power-efficiency / battery-life. Additionally, macOS has excellent support for
a bunch of non-free software, specifically the office-suite. These are the two
main reasons for me to use a mac.

As far as a proprietary systems goes, then macOS can be comfortable, it comes
with ``vim`` and a decent ``Terminal.app``. However, just remember that if you
want to change anything kernel-wise, then you are stuck. And when you go down
the route of disabling system protection, then macOS quickly becomes unstable
and **very** annoying.

So, sticking within the provided system sandbox seems like the best use of a
mac, for me atleast. Allowing myself the use of things like Yabai, to spend
less time moving and resizing windwows.

Brew
----

Apple provides an App store, however, it requires logging in with an
Apple-account. Plus, it is a graphical application, I much prefer a
software/package manager in the ``SHELL``.
Thus, I go with the Brew package manager. In addition to providing packages,
then it also provides a service-controller. So, when installing a **daemon**,
then you can start/stop it via ``brew services``.

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

Python
------

A recent Python interpreter comes with macOS, thus no need to grab a newer one
via Brew, thus, just setup you shell to expand ``PATH`` with the executables
provided via Python packages:

.. literalinclude:: 600_python_bin.cmd
   :language: bash

Rust
----

Install via untrusted sources:

.. literalinclude:: 200_rustup_install.cmd
   :language: bash

setting ``PATH``.

LunarVim
--------

macOS comes with vim, which is pretty great! However, much like ``vim`` was an
improvement over ``vi``, then the extended ``neovim`` is a potential
evolutionary step to the greatest text-editor ever.

Projects such as LunarVim, turns ``neovim`` into an IDE.

.. literalinclude:: 700_lunar.cmd
   :language: bash

Window Manager
--------------

Edit the Yabai configuration ``vim ~/.yabairc``:

.. literalinclude:: yabairc
   :language: bash

Edit short-cuts for Yabai by using skhd ``vim  ~/.skhdrc``:

.. literalinclude:: skhdrc
   :language: bash

Yabai is controlled via brew-services::

  brew services start yabai

iTerm2
------

* Appearance -> General -> Theme: Compact

* Profiles -> Colors -> Color Presets: Solarized Dark

* Profiles -> Colors -> Font: DejaVuSansMono Nerd Font 18

cdrtools
--------

Using cloud-init tools... images... recall which tool was used here.

macOS Settings
--------------

The stuff below are settings in the macOS Ventura System Settings:

* Appearance

  * Appearance: Dark
  * Sidebar icon size: Large

* Desktop & Dock

  * Position on Screen: Left

* Keyboard

  * Keyboard Shortcuts -> Modifier Keys

    * Select keyboard: Apple Internal Keyboard / Trackpad
    * Caps Lock key: Control

  * Keyboard Shortcuts -> Modifier Keys

    * Select keyboard: USB Keyboard
    * Caps Lock key: Control
    * Option key: Command
    * Command key: Option

* Trackpad

  * Scroll & Zoom -> Natural scrolling: off

macOS Tweaks
------------

The **tweaks** are things which I haven't found a convenient way to configure
via ``Settings.app``. Howevever, they are still within the functionality of the
macOS sandbox.

Home/End
~~~~~~~~

When hitting the physcial Home/End keys on a keyboard, which actually have
those keys, then it moves the text-cursor to the begginning / end of the line.
Additionally, then shift/move selects text.

Create the file ``~/Library/KeyBindings/DefaultKeyBinding.dict``, with the content:

.. literalinclude:: DefaultKeyBinding.dict
   :language: bash

Unfortunately, then this does not work for everything... however... better than
nothing.
