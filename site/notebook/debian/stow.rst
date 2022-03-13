Stowing Dotfiles
----------------

There is a trend of using a massive dotfile collection such as yadr, to me I
prefer keeping it barebones::

  sudo apt-get -qy install stow

Layout of dotfiles, inside some directory, do::

  stow -t ~ byobu

Unlink::

  stow -t ~ -D byobu
