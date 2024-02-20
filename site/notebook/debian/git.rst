Git
---

Install::

  sudo apt-get install \
    git \
    gitk \
    git-gui \
    meld

Setup the default email and username for git:

.. code-block:: bash

  # Author
  git config --global user.email os@safl.dk
  git config --global user.name "Simon A. F. Lund"

  # Tools
  git config --global core.editor hx
  git config --global merge.tool meld

And do the same in repository:

.. code-block:: bash

  # Author
  git config user.email os@safl.dk
  git config user.name "Simon A. F. Lund"

  # Tools
  git config core.editor hx
  git config merge.tool meld