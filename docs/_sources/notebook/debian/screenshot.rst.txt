Screenshots of Lightdm
======================

There are plenty of great tools to taking screenshots **after** signing into /
starting your xorg session. However, how to deal with taking a picture of
lightdm itself?

First, ensure you have these:

.. code-block:: bash

  sudo apt-get -qy install x11-apps imagemagick

Then create ``/tmp/capture.sh`` filling it with:

.. literalinclude:: capture.sh
   :language: bash

Then, logout and once you are at the Lightdm login screen, then hit ``Ctrl + Alt + F2``. This will bring you to a console login-screen. Login, then execute:

.. code-block::

  sudo /tmp/capture.sh

Then hit ``Alt + F7`` to get back to the Light login screen. Wait 5 seconds, then login.
Look in ``/tmp`` for files named ``lightdm-*.jpg``
