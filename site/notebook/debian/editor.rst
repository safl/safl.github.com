Text Editors
============

Text-editing, the main tool for developers.

Vim
---

Install::

  sudo apt-get -qy install \
    git \
    vim-gtk

The above get's us vim and git to install vim-plugins. The following are
dependencies for plugins, installing them ahead of time::

  sudo apt-get -qy install \
    build-essential \
    cmake \
    default-jdk \
    golang \
    mono-complete \
    nodejs \
    npm \
    python3-dev \
    vim-nox

Configuration
~~~~~~~~~~~~~

Create directory layout and initial configuration file::

  mkdir .vim
  touch .vimrc

Plugin Manager
~~~~~~~~~~~~~~

vundle or pathogen::

  git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

Provide the plugin-manager configuration as the first thing in your ``.vimrc``:

.. literalinclude:: ../../../dotfiles/vim/.vimrc
   :language: vim
   :emphasize-lines: 0,27
   :linenos:

Then install the plugin-manager, by running the following command inside ``vim``::

  :PluginInstall

Code-Completion
~~~~~~~~~~~~~~~

Go ahead, build and install YouCompleteMe(YCM)::

  cd ~/.vim/bundle/youcompleteme
  # For c only
  #python3 install.py --clangd-completer
  python3 install.py --all

Clipboard
~~~~~~~~~

...

Indentation
~~~~~~~~~~~

...


https://vimawesome.com/plugin/vim-colors-solarized-ours

https://shapeshed.com/vim-netrw/
