MacOS
=====

These are a couple of notes on how I like to use a Mac with macOS on it, and
why I bother.

Those Apple Silicon based Macs are pretty awesome, especially in terms of
power-efficiency / battery-life. Additionally, macOS has excellent support for
free as well as non-free software, specifically the office-suite. These are the
two main reasons for me to use macOS on a Mac.

As far as a proprietary systems goes, then macOS can be comfortable, it get you
started with ``vim`` and a decent ``Terminal.app``. However, just remember that
if you want to change anything kernel-wise, then you are stuck. And when you go
down the route of disabling system protection, then macOS quickly becomes
unstable and **very** annoying.

So, sticking within the provided system sandbox seems like the best use of a
mac, for me atleast. Allowing myself the use of things like **Yabai**, to spend
less time moving and resizing windwows.

Settings
--------

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

Tweaks
------

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
via Brew. However, what is nice, is using ``pipx`` to manage Python-based
cli-tools. Thus ensure you run:

.. literalinclude:: 540_pipx_ensurepath.cmd

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

iTerm2
------

The ``Terminal.app`` is great, however for use with ``lvim``, then better
color-support is needed. Also, ``iTerm2.app`` has been the "category-killer"
for Terminal applications on macOS for 10+ years. Thus, when looking to
customize/configuring something, then there is more hits on ``iTerm2.app`` over
``Terminal.app`` simply due to its popularity.

* iTerm2 -> Settings -> Appearance

  * General -> Theme: Compact

* iTerm2 -> Settings -> Profiles -> Profile Name: Default
  
  * General -> Working Directory: Reuse preivous session's directory
  * Colors -> Color Presets: Solarized Dark
  * Colors -> Font: DejaVuSansMono Nerd Font 18

Window Manager
--------------

**Yabai** is a tiling window manager, other alternatives include Amethyst, and the
very simple ``Rectangle.app``. I tried out ``Rectangle.app`` but got frustrated
as it allows be to position windows, however, it does not automatically manage
their position as a tiling window manager does. When coming from e.g. i3 on
Linux, then it is worth noting that macOS was not built for this, also, it is
very easy to disable window-management for things like ``Calculator.app`` and
``System Settings.app``.

Thus, if ``yabai`` is getting in the way, then disable it for certain
applications. Also, it can be completely switched off easily withouth bring
down everything. Thus, it is relatively "safe" to use what it provides, and opt
out when it fails you.

Edit the **Yabai** configuration ``vim ~/.yabairc``:

.. literalinclude:: yabairc
   :language: bash

Edit shortcuts for **Yabai** by using skhd ``vim  ~/.skhdrc``:

.. literalinclude:: skhdrc
   :language: bash

**Yabai** is controlled via brew-services::

  brew services start yabai

Meld
----

Meld is not officially supported on macOS, however, unofficially ``.dmg``
exists and they are installable via ``brew``. However, they are not **signed**
and thus, not allowed to run on Ventura. Here is an unsafe way to work around
that short-coming::

  xattr -r -d com.apple.quarantine /Applications/Meld.app/

DS_STORE
--------

Do::

       defaults write com.apple.desktopservices DSDontWriteNetworkStores true

.. note::
   Does not take effect until after logout/reboot.

cdrtools
--------

Using cloud-init tools... images... recall which tool was used here.

Microsoft Office
----------------

This thing just works, with OneDrive sync and everything with your Microsoft
Account. One note, regarding the use of Outlook and Exchange, To utilize this,
then first log into Word/Excel/OneDrive, because then the office-suite knows
that it is **licenced**.

Then you can open Outlook, and in "Help", there is an option "Revert to
Legacy". With this version Exchange is functional.

Short-comings
=============

I miss the following tools:

* cloud-init
* pahole
* A native / fast use of Docker and Podman, that is, native containers...

And I miss the i3 setup I have on Debian.
