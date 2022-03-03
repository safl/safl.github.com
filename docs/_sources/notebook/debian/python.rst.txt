Python Linter-tools
~~~~~~~~~~~~~~~~~~~

To get the latest and greatest versions then install them via ``pip3`` and
ensure that they are not installed on the system::

  # Make sure the package-manger versions are not installed
  sudo apt remove \
    flake8 \
    pylint3 \
    mypy
  sudo apt autoremove

  # Install them system-wide via pip3
  sudo pip3 install \
    mypy \
    flake8 \
    pylint
