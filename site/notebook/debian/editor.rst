Text Editors
============

I have used vim for some 20+ years. I have tried neovim at several occassions
and not felt an urge to switch. However, at some pointin 2023 a co-worker of
mine showed me LunarVIM and i took it for a spin. I liked it, and ditched my
handrolled vim configs in favor of the turn-key setup provided by LunarVIM.

At that stage nothing felt sacred anymore and at that point then the very same
co-worker showed me the Helix editor, then I decided to just go all-in.

The only thing I don't like about the Helix editor are two tings:

* There are no packages for Debian Linux
* The name of the executable ``hx``. I might just be scarred from typing ``vim``
  for decades.

So, currently piloting vanilla ``vi`` and ``vim`` on systems where they are
available, and for my main text-editor and code-mangling I use Helix. Thus, this
page is re-written with notes on getting the Helix editor running.

Install from source
-------------------

Do this:

.. code-block:: bash

  # Build and install
  cd ~/git
  git clone https://github.com/helix-editor/helix
  cd helix
  cargo install --path helix-term --locked

  # Runtime Files
  hx --health
  ln -Ts $PWD/runtime ~/.config/helix/runtime
  hx --grammar fetch
  hx --grammar build
  hx --health

  # Create a system-wide symlink named 'lvim'
  sudo ln -s /home/safl/.cargo/bin/hx /usr/local/bin/lvim

It might seem like weird thing to name a symlink for the Helix Editor. However,
as mentioned, then I have used vim for a long time, so it is ingrained in my
muscle-memory. The addition of ``l`` infront comes from when I used Lunar VIM.
Thus, today, I like to use they plain version of vi-iMprovied using ``vim`` and
then having my *fancy* editor at ``lvim``.

Configs
-------

``~/.config/helix/languages.toml``:

.. literalinclude:: ../../../dotfiles/helix/.config/helix/languages.toml

``~/.config/helix/config.toml``:

.. literalinclude:: ../../../dotfiles/helix/.config/helix/config.toml


xorg clipboard (Space+Y)
------------------------

Needs these packages as well:

.. code-block:: bash

  sudo apt-get install -qy xsel xclip