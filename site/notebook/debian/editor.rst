Text Editors
============

Text-editing, the main tool for developers.

Vim
---

Install::

        sudo apt-get -qy install \
                git \
                vim-gtk

Configuration
~~~~~~~~~~~~~

Create directory layout and initial configuration file::

        mkdir .vim
        touch .vimrc

Plugin Manager
~~~~~~~~~~~~~~

vundle or pathogen.

        git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

Provide the plugin-manager configuration as the first thing in your ``.vimrc``:

.. literalinclude:: ../../dotfiles/vim/.vimrc
   :language: vim
   :emphasize-lines: 0,27
   :linenos: 

Then install the plugin-manager, by running the following command inside ``vim``::

        :PluginInstall
...

Clipboard
~~~~~~~~~

...

Indentation
~~~~~~~~~~~

...


https://vimawesome.com/plugin/vim-colors-solarized-ours

https://shapeshed.com/vim-netrw/
