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

Configs
-------

``~/.config/helix/languages.toml``:

.. literalinclude:: ../../../dotfiles/config/helix/languages.toml

``~/.config/helix/config.toml``:

.. literalinclude:: ../../../dotfiles/config/helix/config.toml
